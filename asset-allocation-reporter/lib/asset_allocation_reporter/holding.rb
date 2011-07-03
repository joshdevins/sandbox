module AssetAllocationReporter
  class Holding
    
    attr_reader :stock
    attr_reader :shares_owned
    attr_reader :currency
    attr_reader :book_value
    
    def initialize(stock, shares_owned, currency)
      @stock = stock
      @shares_owned = shares_owned
      @currency = Money::Currency.new(currency)
      
      @book_value = stock.last_trade.exchange_to(@currency) * shares_owned
    end
    
    def to_s
      return "#{stock} [shares=#{shares_owned} book_value=#{book_value.currency}#{book_value.currency.symbol}#{book_value}]"
    end
    
    def to_str
      return stock.to_str
    end
  end
end