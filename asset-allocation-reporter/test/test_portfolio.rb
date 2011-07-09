require 'minitest/autorun'

require 'asset_allocation_reporter'

module AssetAllocationReporter
  class TestPortfolio < MiniTest::Unit::TestCase
    
    def test_portfolio_merge
      
      # setup test stocks
      aapl = Stock.new(AssetAllocationReporter::EXCHANGE_INDEX['NASDAQ'], "AAPL", "Apple",
                       Money.new(5000, "CAD"), Money.new(10000000000000, "CAD"), AssetAllocationReporter::INDUSTRY_INDEX[811])
      ibm = Stock.new(AssetAllocationReporter::EXCHANGE_INDEX['NASDAQ'], "IBM", "IBM",
                      Money.new(500, "CAD"), Money.new(10000000000, "CAD"), AssetAllocationReporter::INDUSTRY_INDEX[811])
      
      # merge same stock
      portfolio1 = Portfolio.new("portfolio1", :cad, [Holding.new(aapl, 50, :cad)])
      portfolio2 = Portfolio.new("portfolio2", :cad, [Holding.new(aapl, 50, :cad)])
      portfolio1.merge!(portfolio2)
      
      assert_equal(1, portfolio1.holdings.size)
      assert_equal(100, portfolio1.holdings[0].shares_owned)
      assert_equal(Money.new(100 * 5000, "CAD"), portfolio1.holdings[0].book_value)
      assert_equal(portfolio1.holdings[0].book_value, portfolio1.book_value)
      
      # merge two different stocks
      portfolio2 = Portfolio.new("portfolio2", :cad, [Holding.new(ibm, 10, :cad)])
      portfolio1.merge!(portfolio2)
      
      assert_equal(2, portfolio1.holdings.size)
      assert_equal(Money.new(100 * 5000, "CAD") + (ibm.last_trade * 10), portfolio1.book_value)
    end
  end
end