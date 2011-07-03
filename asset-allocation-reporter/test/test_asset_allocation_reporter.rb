require 'minitest/autorun'

require 'asset_allocation_reporter'

module AssetAllocationReporter
  class TestExchangeFactory < MiniTest::Unit::TestCase
    
    def test_asset_allocation_reporter
      # set default bank to instance of GoogleCurrency
      Money.default_bank = Money::Bank::GoogleCurrency.new
      
      # load exchange index
      exchange_index = ExchangeFactory.parse_exchange_index('lib/asset_allocation_reporter/data/exchanges.csv')

      # load industry index
      industry_index_html = Nokogiri::HTML(open('http://biz.yahoo.com/ic/ind_index.html'))
      industry_index = IndustryFactory.parse_yahoo_industry_index(industry_index_html)

      # stocks
      lookup = [LookupStock.new('AAPL',),
                LookupStock.new('GOOG'),
                LookupStock.new('TRI', 'TSE')]

      stocks = StockFactory.lookup_stocks(lookup, exchange_index, industry_index)

      # portfolios
      current_portfolio = Portfolio.new("CAD$ non-reg'd", :cad, stocks)

      puts "Current portfolio:"
      current_portfolio.print
      puts
    end
  end
end