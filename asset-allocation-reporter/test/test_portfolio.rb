require 'minitest/autorun'

require 'asset_allocation_reporter'

module AssetAllocationReporter
  class TestPortfolio < MiniTest::Unit::TestCase
    
    def test_portfolio_merge
      
      # set default bank to instance of GoogleCurrency
      Money.default_bank = Money::Bank::GoogleCurrency.new
      
      # load exchange index
      exchange_index = ExchangeFactory.parse_exchange_index('lib/asset_allocation_reporter/data/exchanges.csv')

      # load industry index
      industry_index_html = Nokogiri::HTML(open('http://biz.yahoo.com/ic/ind_index.html'))
      industry_index = IndustryFactory.parse_yahoo_industry_index(industry_index_html)
      
      # setup test stocks
      aapl = Stock.new(exchange_index['NASDAQ'], "AAPL", "Apple", Money.new(5000, "CAD"), Money.new(10000000000000, "CAD"), industry_index[811])
      ibm = Stock.new(exchange_index['NASDAQ'], "IBM", "IBM", Money.new(500, "CAD"), Money.new(10000000000, "CAD"), industry_index[811])
      
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