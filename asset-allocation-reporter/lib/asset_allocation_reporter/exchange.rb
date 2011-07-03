module AssetAllocationReporter
  class Exchange
    
    attr_reader :country
    attr_reader :currency
    attr_reader :name
    attr_reader :google_symbol
    attr_reader :yahoo_symbol
    attr_reader :yahoo_ws_symbol
    
    def initialize(country, currency, name, google_symbol, yahoo_symbol, yahoo_ws_symbol)
      @country = country
      @currency = currency
      @name = name
      @google_symbol = google_symbol
      @yahoo_symbol = yahoo_symbol
      @yahoo_ws_symbol = yahoo_ws_symbol
      
      self.freeze
    end
    
    def ==(other)
      return true if self.equal?(other)
      return false unless other.class == self.class
      return false unless other.instance_variables == self.instance_variables
      
      return @country == other.country && @name == other.name
    end
  
    def eql?(other)
      return self == other
    end
  
    def hash
      return "#{country} #{name}".hash
    end
    
    def to_s
      "country=#{country}, currency=#{currency}, name=#{name}; symbols: Google=#{google_symbol}, Yahoo=#{yahoo_symbol}, Yahoo WS=#{yahoo_ws_symbol}"
    end
    
    def to_str
      return name
    end
  end
end