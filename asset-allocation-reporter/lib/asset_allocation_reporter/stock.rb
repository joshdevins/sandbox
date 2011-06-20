module AssetAllocationReporter
  class Stock
  
    attr_reader :exchange
    attr_reader :symbol
    attr_reader :name
    attr_reader :last_trade
    attr_reader :market_cap
    attr_reader :industry
  
    def initialize(exchange, symbol, name, last_trade, market_cap, industry)
      @exchange = exchange
      @symbol = symbol
      @name = name
      @last_trade = last_trade
      @market_cap = market_cap
      @industry = industry
    end
  
    def to_s
      "#{exchange}:#{symbol}, name=#{name}, last_trade=#{last_trade}, market_cap=#{market_cap}, industry=#{industry}"
    end
    
    def to_str
      return name
    end
    
    # latest (net, gross) revenue by geography
  end
end