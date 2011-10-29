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
      assert_equal(millions * 1000, StockFactory.parse_market_cap("32.1B\n", 'USD'))
      assert_equal(millions * 1000 * 1000, StockFactory.parse_market_cap('32.1T', 'USD'))
      assert_raises(RuntimeError) { StockFactory.parse_market_cap('32.1A', 'USD') }
      assert_raises(RuntimeError) { StockFactory.parse_market_cap('32.1', 'USD') }
    end
    
    def test_parse_yahoo_profile_page_found_but_no_data
      
      # BRK-B
      assert_nil(StockFactory.parse_yahoo_profile_page_for_industry_id("BRK-B"))
    end
    
    def test_parse_yahoo_profile_page_not_found
      
      # DH.TO
      assert_nil(StockFactory.parse_yahoo_profile_page_for_industry_id("DH.TO"))
    end
    
    def test_get_yahoo_stock_data_no_industry_or_market_cap

      lookup = [LookupStock.new(:berkshire, 'BRK-B'),
                LookupStock.new(:davis, 'DH', 'TSE')]
                
      stocks = StockFactory.lookup_stocks(lookup)

      assert_equal(lookup.size, stocks.size)
      
      # both should have no industry data set
      assert_equal('BRK-B', stocks[:berkshire].symbol)
      assert_equal(AssetAllocationReporter::NIL_INDUSTRY, stocks[:berkshire].industry)
      refute_nil(stocks[:berkshire].market_cap)
      
      assert_equal('DH', stocks[:davis].symbol)
      assert_equal(AssetAllocationReporter::NIL_INDUSTRY, stocks[:davis].industry)
      refute_nil(stocks[:davis].market_cap)
    end
    
    def test_get_yahoo_stock_data
    
      # lookup stocks
      lookup = [LookupStock.new(:aapl, 'AAPL', 'NASDAQ'),
                LookupStock.new(:goog, 'GOOG'),
                LookupStock.new(:ibm, 'IBM'),
                LookupStock.new(:ibm_nyse, 'IBM', 'NYSE'),
                LookupStock.new(:tri, 'TRI', 'TSE')]
    
      stocks = StockFactory.lookup_stocks(lookup)
    
      assert_equal(lookup.size, stocks.size)
    
      # AAPL
      assert_equal(AssetAllocationReporter::EXCHANGE_INDEX['NASDAQ'], stocks[:aapl].exchange)
      assert_equal('AAPL', stocks[:aapl].symbol)
      assert_equal('Apple Inc.', stocks[:aapl].name)
      assert_equal(811, stocks[:aapl].industry.id)
    
      # GOOG
      assert_equal(AssetAllocationReporter::EXCHANGE_INDEX['NASDAQ'], stocks[:goog].exchange)
      assert_equal('GOOG', stocks[:goog].symbol)
      assert_equal('Google Inc.', stocks[:goog].name)
      assert_equal(851, stocks[:goog].industry.id)
    
      # IBM
      assert_equal(AssetAllocationReporter::EXCHANGE_INDEX['NYSE'], stocks[:ibm].exchange)
      assert_equal('IBM', stocks[:ibm].symbol)
      assert_equal('International Bus', stocks[:ibm].name)
      assert_equal(810, stocks[:ibm].industry.id)
    
      # Thomson Reuters - TSE
      assert_equal(AssetAllocationReporter::EXCHANGE_INDEX['TO'], stocks[:tri].exchange)
      assert_equal('TRI', stocks[:tri].symbol)
      assert_equal('THOMSON REUTERS C', stocks[:tri].name)
      assert_equal(760, stocks[:tri].industry.id)
    end
  end
end