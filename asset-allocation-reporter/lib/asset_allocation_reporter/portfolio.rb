module AssetAllocationReporter
  class Portfolio
  
    attr_reader :name
    attr_reader :currency
    attr_reader :stocks
  
    def initialize(name, currency, stocks)
      @name = name
      @currency = Money::Currency.new(currency)
      @stocks = stocks
      @stocks.map do |stock|
        
        if (stock.exchange.currency != currency) {
          
          stock.market_cap = stock.market_cap.exchange_to(currency)
          stock.book_value = stock.book_value.exchange_to(currency)
        end
      end
    end
  
    def print
      puts @name
      puts @currency
      @stocks.each { |stock| puts stock }
    end
  end
end