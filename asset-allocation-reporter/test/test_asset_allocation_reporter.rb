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
      lookup = [
        LookupStock.new('AAPL',),
        LookupStock.new('DELL'),
        LookupStock.new('TRI', 'TSE')]

      stocks = StockFactory.lookup_stocks(lookup, exchange_index, industry_index)

      # portfolios
      current_portfolio_holdings = [
        Holding.new(stocks[0], 10, :cad),
        Holding.new(stocks[1], 10, :cad),
        Holding.new(stocks[2], 100, :cad)]
      current_portfolio = Portfolio.new("CAD$ non-reg'd", :cad, current_portfolio_holdings)

      puts "Current portfolio:"
      current_portfolio.print
      puts
      
      puts "Current portfolio allocations:"
      puts "by symbol"
      current_portfolio.print_allocation_by { |holding| holding.stock.symbol }
      puts
      puts "by sector"
      current_portfolio.print_allocation_by { |holding| holding.stock.industry.sector }
      puts
      puts "by industry"
      current_portfolio.print_allocation_by { |holding| holding.stock.industry }
      puts
    end
  end
end