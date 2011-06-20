require 'minitest/autorun'

require 'asset_allocation_reporter'

class TestStockFactory < MiniTest::Unit::TestCase

  def test_parse_yahoo_profile_page
    html = Nokogiri::HTML(open('http://finance.yahoo.com/q/pr?s=AAPL+Profile'))
    sector_id, industry_id = parse_yahoo_profile_page(html)
    
    assert_equal(8, sector_id)
    assert_equal(811, industry_id)
  end
  
  def test_get_yahoo_stock_data
    
    # load industry index
    industry_index_html = Nokogiri::HTML(open('http://biz.yahoo.com/ic/ind_index.html'))
    industry_index = AssetAllocationReporter::IndustryFactory.parse_yahoo_industry_index(industry_index_html)
    
    # load exchange index
    exchange_index = AssetAllocationReporter::ExchangeFactory.parse_exchange_index('lib/asset_allocation_reporter/data/exchanges.csv')
    
    # lookup stocks
    lookup = [AssetAllocationReporter::LookupStock.new('AAPL', 'NASDAQ'),
              AssetAllocationReporter::LookupStock.new('GOOG'),
              AssetAllocationReporter::LookupStock.new('IBM'),
              AssetAllocationReporter::LookupStock.new('IBM', 'NYSE'),
              AssetAllocationReporter::LookupStock.new('TRI', 'TSE')]
    
    # lookup proper Yahoo! symbol
    lookup.each do |s|
      
      # no exchange provided, just have to try without one
      if s.exchange == nil || s.exchange.empty?
        s.exchange = ''
        next
      end
      
      # exchange provided
      exchange = exchange_index[s.exchange]
      if (exchange)
        s.exchange = exchange
      else
        puts "Could not find exchange with symbol: #{s.exchange}"
        s.exchange = nil
      end
    end
    
    # remove any nil items, unkown exchanges
    lookup = lookup.keep_if {|s| s.exchange != nil}
    
    # convert to lookup symbols
    lookup_symbols = lookup.map { |s| s.get_lookup_symbol }
    symbols_str = lookup_symbols.join('+')
    
    columns = {
      exchange: 'x',
      name: 'n',
      market_cap: 'j1',
    }
    
    stocks = []
    conn = open("http://finance.yahoo.com/d/quotes.csv?s=#{URI.escape(symbols_str)}&f=#{columns.values.join}")
    
    csv = CSV.parse(conn.read, :headers => columns.keys)
    csv.each_with_index do |row, index|
      
      # figure out the exchange if none was set
      exchange = lookup[index].exchange
      if (exchange == '')
        exchange = exchange_index[row[:exchange]]
        
        # verify exchnage was found
        if (exchange == nil)
          puts "Exchange returned from Yahoo! is not in the exchange index: #{row[:exchange]}. Skipping stock: #{lookup[index]}"
          next
        end
      end
      
      # get the profile
      profile_html = Nokogiri::HTML(open("http://finance.yahoo.com/q/pr?s=#{lookup_symbols[index]}+Profile"))
      sector_id, industry_id = parse_yahoo_profile_page(profile_html)
      
      # verify industry in index
      industry = industry_index[industry_id]
      if (industry == nil)
        puts "Industry returned from Yahoo! is not in the industry index: #{industry_id}. Skipping stock: #{lookup[index]}"
        next
      end
      
      # done
      stocks << AssetAllocationReporter::Stock.new(exchange, lookup[index].symbol, row[:name], row[:market_cap], industry)
    end
    
    assert_equal(lookup.size, stocks.size)
    
    # AAPL
    assert_equal(exchange_index['NASDAQ'], stocks[0].exchange)
    assert_equal('AAPL', stocks[0].symbol)
    assert_equal('Apple Inc.', stocks[0].name)
    assert_equal(811, stocks[0].industry.id)
    
    # GOOG
    assert_equal(exchange_index['NASDAQ'], stocks[1].exchange)
    assert_equal('GOOG', stocks[1].symbol)
    assert_equal('Google Inc.', stocks[1].name)
    assert_equal(851, stocks[1].industry.id)
    
    # IBM
    assert_equal(exchange_index['NYSE'], stocks[2].exchange)
    assert_equal('IBM', stocks[2].symbol)
    assert_equal('International Bus', stocks[2].name)
    assert_equal(810, stocks[2].industry.id)
    
    # Thomson Reuters - TSE
    assert_equal(exchange_index['TO'], stocks[4].exchange)
    assert_equal('TRI', stocks[4].symbol)
    assert_equal('THOMSON REUTERS C', stocks[4].name)
    assert_equal(760, stocks[4].industry.id)
  end
  
  def parse_yahoo_profile_page(html)
    
    industry_html = html.xpath('/html/body/div/div[3]/table[2]/tr[2]/td/table[2]/tr/td/table/tr[3]/td[2]/a')
    return AssetAllocationReporter::IndustryFactory.parse_sector_and_industry_ids_from_url(industry_html.attribute('href').value)
  end
end
