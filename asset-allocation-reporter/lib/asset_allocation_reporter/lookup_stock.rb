module AssetAllocationReporter
    class LookupStock
  
    # exchanges on Yahoo! that have no suffix in the symbol
    NULL_EXCHANGES = ['NASDAQ', 'NYSE', 'AMEX']
  
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

      if exchange == nil || exchange.empty? || NULL_EXCHANGES.include?(exchange)
        return symbol
      else
        return symbol + '.' + exchange
      end
    end
  end
end