module AssetAllocationReporter
    class Stock
  
    attr_reader :exchange
    attr_reader :ticker
    attr_reader :name
    attr_reader :currency
    attr_reader :market_cap
    attr_reader :industry
  
    def initialize(exchange, ticker, name, currency, market_cap, industry)
      @exchange = exchange
      @ticker = ticker
      @name = name
      @currency = currency
      @market_cap = market_cap
      @industry = industry
    end
  
    def to_s
      "#{exchange}:#{ticker}, name=#{name}, currency=#{currency}, market_cap=#{market_cap}M, sector=#{sector}, industry=#{industry}"
    end
    
    def to_str
      return name
    end
    
    # latest (net, gross) revenue by geography
  end
end