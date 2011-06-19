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
    require 'csv'
    
    stocks = []
    lookup = [AssetAllocationReporter::LookupStock.new('AAPL', 'NASDAQ'),
              AssetAllocationReporter::LookupStock.new('GOOG')]
    
    symbols = lookup.map {|s| s.get_lookup_symbol}
    symbols_str = symbols.join('+')
    
    conn = open("http://finance.yahoo.com/d/quotes.csv?s=#{URI.escape(symbols_str)}&f=xsnj1")
    csv = CSV.parse(conn.read) { |row|
      
      exchange = row[0]
      symbol = row[1]
      name = row[2]
      market_cap = row[3]
      
      stocks << AssetAllocationReporter::Stock.new(exchange, symbol, name, market_cap, nil)
    }
    
    assert_equal(lookup.size, stocks.size)
    assert_equal('NasdaqNM', stocks[0].exchange)
    assert_equal('AAPL', stocks[0].symbol)
    assert_equal('Apple Inc.', stocks[0].name)
  end
  
  def parse_yahoo_profile_page(html)
    
    industry_html = html.xpath('/html/body/div/div[3]/table[2]/tr[2]/td/table[2]/tr/td/table/tr[3]/td[2]/a')
    return AssetAllocationReporter::IndustryFactory.parse_sector_and_industry_ids_from_url(industry_html.attribute('href').value)
  end
end
