module AssetAllocationReporter
  class Portfolio
  
    def initialize(stocks)
      @stocks = stocks
    end
  
    def print
      @stocks.each { |stock| puts stock }
    end
  end
end