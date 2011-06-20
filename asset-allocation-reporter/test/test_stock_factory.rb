require 'minitest/autorun'

require 'asset_allocation_reporter'

class TestStockFactory < MiniTest::Unit::TestCase
  
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
    
    stocks = AssetAllocationReporter::StockFactory.lookup_stocks(lookup, exchange_index, industry_index)
    
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
end
