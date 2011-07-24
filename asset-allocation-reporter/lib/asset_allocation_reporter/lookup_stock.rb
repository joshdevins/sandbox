module AssetAllocationReporter
    class LookupStock
  
    attr_reader :internal_symbol
    attr_reader :symbol
    attr_accessor :exchange
  
    def initialize(internal_symbol, symbol, exchange = nil)
      @internal_symbol = internal_symbol
      @symbol = symbol
      @exchange = exchange
    end
  
    def get_lookup_symbol

      if (exchange == '' or exchange.yahoo_symbol == nil or exchange.yahoo_symbol == '')
        return symbol
      else
        return symbol + '.' + exchange.yahoo_symbol
      end
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
      return to_s.hash
    end
  
    def to_s
      "#{exchange}:#{symbol}"
    end
  end
end