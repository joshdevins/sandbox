module AssetAllocationReporter
    class LookupStock
  
    attr_reader :exchange
    attr_reader :symbol
  
    def initialize(symbol, exchange = nil)
      @symbol = symbol
      @exchange = exchange
    end
  
    def to_s
      "#{exchange}:#{symbol}"
    end
    
    def get_lookup_symbol

      if exchange == nil || exchange.empty?
        return symbol
      else
        return symbol + '.' + exchange
      end
    end
  end
end