require 'minitest/autorun'

require 'asset_allocation_reporter'

module AssetAllocationReporter
  class TestStockFactory < MiniTest::Unit::TestCase
  
    def test_parse_yahoo_profile_page_for_industry_id      
      assert_equal(811, StockFactory.parse_yahoo_profile_page_for_industry_id('AAPL'))
    end
  
    def test_parse_market_cap
      
      millions = Money.new(32.1 * 1000000 * 100, 'USD') # in cents
      assert_equal(millions, StockFactory.parse_market_cap('32.1M', 'USD'))
      assert_equal(millions * 1000, StockFactory.parse_market_cap('32.1B', 'USD'))
      assert_equal(millions * 1000 * 1000, StockFactory.parse_market_cap('32.1T', 'USD'))
      assert_raises(RuntimeError) { StockFactory.parse_market_cap('32.1A', 'USD') }
      assert_raises(RuntimeError) { StockFactory.parse_market_cap('32.1', 'USD') }
    end
  
    def test_get_yahoo_stock_data
    
      # lookup stocks
      lookup = [LookupStock.new('AAPL', 'NASDAQ'),
                LookupStock.new('GOOG'),
                LookupStock.new('IBM'),
                LookupStock.new('IBM', 'NYSE'),
                LookupStock.new('TRI', 'TSE')]
    
      stocks = StockFactory.lookup_stocks(lookup)
    
      assert_equal(lookup.size, stocks.size)
    
      # AAPL
      assert_equal(AssetAllocationReporter::EXCHANGE_INDEX['NASDAQ'], stocks[0].exchange)
      assert_equal('AAPL', stocks[0].symbol)
      assert_equal('Apple Inc.', stocks[0].name)
      assert_equal(811, stocks[0].industry.id)
    
      # GOOG
      assert_equal(AssetAllocationReporter::EXCHANGE_INDEX['NASDAQ'], stocks[1].exchange)
      assert_equal('GOOG', stocks[1].symbol)
      assert_equal('Google Inc.', stocks[1].name)
      assert_equal(851, stocks[1].industry.id)
    
      # IBM
      assert_equal(AssetAllocationReporter::EXCHANGE_INDEX['NYSE'], stocks[2].exchange)
      assert_equal('IBM', stocks[2].symbol)
      assert_equal('International Bus', stocks[2].name)
      assert_equal(810, stocks[2].industry.id)
    
      # Thomson Reuters - TSE
      assert_equal(AssetAllocationReporter::EXCHANGE_INDEX['TO'], stocks[4].exchange)
      assert_equal('TRI', stocks[4].symbol)
      assert_equal('THOMSON REUTERS C', stocks[4].name)
      assert_equal(760, stocks[4].industry.id)
    end
  end
end