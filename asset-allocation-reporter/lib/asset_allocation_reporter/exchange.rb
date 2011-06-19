module AssetAllocationReporter
  class Exchange
    
    attr_reader :country
    attr_reader :currency
    attr_reader :name
    attr_reader :google_symbol
    attr_reader :yahoo_symbol
    
    def initialize(country, currency, name, google_symbol, yahoo_symbol)
      @country = country
      @currency = currency
      @name = name
      @google_symbol = google_symbol
      @yahoo_symbol = yahoo_symbol
    end
    
    def to_s
      "country=#{country}, currency=#{currency}, name=#{name}; symbols: Google=#{google_symbol}, Yahoo=#{yahoo_symbol}"
    end
    
    def to_str
      return name
    end
  end
end