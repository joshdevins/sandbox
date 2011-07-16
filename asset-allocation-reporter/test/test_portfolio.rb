require 'minitest/autorun'

require 'asset_allocation_reporter'

module AssetAllocationReporter
  class TestPortfolio < MiniTest::Unit::TestCase
    
    def setup
      # setup test stocks
      @aapl = Stock.new(AssetAllocationReporter::EXCHANGE_INDEX['NASDAQ'], 'AAPL', 'Apple',
                        Money.new(5000, :cad), Money.new(10000000000000, :cad), AssetAllocationReporter::INDUSTRY_INDEX[811])
      @ibm = Stock.new(AssetAllocationReporter::EXCHANGE_INDEX['NASDAQ'], 'IBM', 'IBM',
                       Money.new(500, :cad), Money.new(10000000000, :cad), AssetAllocationReporter::INDUSTRY_INDEX[811])
      @other = Stock.new(AssetAllocationReporter::EXCHANGE_INDEX['NASDAQ'], 'O', 'Other',
                        Money.new(500, :cad), Money.new(10000000000, :cad), AssetAllocationReporter::INDUSTRY_INDEX[711])
    end
    
    def test_portfolio_merge
      
      # merge same stock
      portfolio1 = Portfolio.new('portfolio1', :cad, [Holding.new(@aapl, 50, :cad)])
      portfolio2 = Portfolio.new('portfolio2', :cad, [Holding.new(@aapl, 50, :cad)])
      portfolio1.merge!(portfolio2)
      
      assert_equal(1, portfolio1.holdings.size)
      assert_equal(100, portfolio1.holdings[0].shares_owned)
      assert_equal(Money.new(100 * 5000, :cad), portfolio1.holdings[0].book_value)
      assert_equal(portfolio1.holdings[0].book_value, portfolio1.book_value)
      
      # merge two different stocks
      portfolio2 = Portfolio.new('portfolio2', :cad, [Holding.new(@ibm, 10, :cad)])
      portfolio1.merge!(portfolio2)
      
      assert_equal(2, portfolio1.holdings.size)
      assert_equal(Money.new(100 * 5000, :cad) + (@ibm.last_trade * 10), portfolio1.book_value)
    end
    
    def test_portfolio_merge_into_empty
      
      portfolio0 = Portfolio.new('overall', :cad, [])
      portfolio1 = Portfolio.new('portfolio1', :cad, [Holding.new(@aapl, 10, :cad)])
      portfolio2 = Portfolio.new('portfolio2', :cad, [Holding.new(@ibm, 100, :cad)])
      
      portfolio0.merge!(portfolio1)
      portfolio0.merge!(portfolio2)
      assert_equal(Money.new(100000, :cad), portfolio0.book_value)
      
      allocation = portfolio0.get_allocation_by_symbol
      
      refute_nil(allocation)
      assert_equal(50, allocation[1][1].percentage)
      assert_equal(50, allocation[0][1].percentage)
    end
    
    def test_asset_allocation_by_types
      
      # portfolios
      holdings = [
        Holding.new(@aapl, 4, :cad),
        Holding.new(@ibm, 40, :cad),
        Holding.new(@other, 20, :cad)]
      portfolio = Portfolio.new('portfolio', :cad, holdings)

      # by symbol
      allocation = portfolio.get_allocation_by_symbol
      refute_nil(allocation)
      assert_equal(40, allocation[2][1].percentage)
      assert_equal(40, allocation[1][1].percentage)
      assert_equal(20, allocation[0][1].percentage)

      # by sector
      allocation = portfolio.get_allocation_by_industry
      refute_nil(allocation)
      assert_equal(80, allocation[1][1].percentage)
      assert_equal(20, allocation[0][1].percentage)
    end
  end
end