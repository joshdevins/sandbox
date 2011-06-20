module AssetAllocationReporter
    class LookupStock
  
    attr_reader :symbol
    attr_accessor :exchange
  
    def initialize(symbol, exchange = nil)
      @symbol = symbol
      @exchange = exchange
    end
  
    def to_s
      "#{exchange}:#{symbol}"
    end
    
    def get_lookup_symbol

      if (exchange == '' or exchange.yahoo_symbol == nil or exchange.yahoo_symbol == '')
        return symbol
      else
        return symbol + '.' + exchange.yahoo_symbol
      end
    end
  end
end