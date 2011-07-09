module AssetAllocationReporter
  class Stock
    
    MILLION = 1000 * 1000
    BILLION = MILLION * 1000
   
    # latest (net, gross) revenue by geography
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
  
    def market_cap_segment
      return Stock.determine_market_cap_segment(@market_cap)
    end
  
    def ==(other)
      return true if self.equal?(other)
      return false unless other.class == self.class
      return false unless other.instance_variables == self.instance_variables
      
      return @exchange == other.exchange && @symbol == other.symbol
    end
  
    def eql?(other)
      return self == other
    end
  
    def hash
      return "#{symbol} #{exchange.to_s}".hash
    end
  
    def to_s
      "#{symbol} [exchange=#{exchange.name}, name=#{name}, last_trade=#{last_trade.currency}#{last_trade.currency.symbol}#{last_trade}, market_cap=#{market_cap.currency}#{market_cap.currency.symbol}#{market_cap.cents / 100000000}M, industry=#{industry}]"
    end
    
    def to_str
      return name
    end
    
    def self.determine_market_cap_segment(market_cap)
      return case
      when market_cap >= Money.new(200 * BILLION, market_cap.currency)
        :mega
      when market_cap >= Money.new(5 * BILLION, market_cap.currency)
        :large
      when market_cap >= Money.new(1 * BILLION, market_cap.currency)
        :mid
      when market_cap >= Money.new(300 * MILLION, market_cap.currency)
        :small
      when market_cap >= Money.new(50 * MILLION, market_cap.currency)
        :micro
      else
        :nano
      end
    end
  end
end