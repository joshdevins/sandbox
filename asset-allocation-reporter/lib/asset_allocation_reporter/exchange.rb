module AssetAllocationReporter
  class Exchange
  
    @@SYSTEMS = {
      thomson_reuters: "Thomson Reuters"
      google: "Google"
      yahoo: "Yahoo"
    }
  
    attr_reader :name
    attr_reader :symbols
  
    def initialize(name, symbols)
      @name = name
      @symbols = symbols
    end
  
    def to_s
      symbols_str = symbols.join(', ')
      "#{name}: #{symbols_str}"
    end
  end
end