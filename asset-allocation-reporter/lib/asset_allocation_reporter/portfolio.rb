module AssetAllocationReporter
  class Portfolio
  
    attr_reader :name
    attr_reader :currency
    attr_reader :stocks
  
    def initialize(name, currency, holdings)
      @name = name
      @currency = Money::Currency.new(currency)
      @holdings = holdings
    end
  
    def print
      puts @name
      puts @currency
      @holdings.each { |holding| puts holding }
    end
  end
end