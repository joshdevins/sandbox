module AssetAllocationReporter
  class Portfolio
  
    attr_reader :name
    attr_reader :currency
    attr_reader :stocks
    attr_reader :book_value
  
    def initialize(name, currency, holdings)
      @name = name
      @currency = Money::Currency.new(currency)
      @holdings = holdings
      @book_value = holdings.reduce(Money.new(0, @currency)) { |memo, holding| memo + holding.book_value }
    end
  
    def print
      puts @name
      puts @currency
      @holdings.each { |holding| puts holding }
      puts "TOTAL #{book_value.currency}#{book_value.currency.symbol}#{book_value}"
    end
    
    def get_allocation_by
      by_x = {}
      
      # collect holdings by x (industry, sector, etc.)
      @holdings.each { |holding| (by_x[yield holding] ||= []) << holding }
      
      # create segments for each x (industry, sector, etc.)
      by_x.each_pair { |x, holdings| by_x[x] = AllocationSegment.new(@book_value, holdings) }

      # sort and return
      return by_x.sort{ |a, b| a[1].percentage <=> b[1].percentage }
    end
    
    def print_allocation_by(&block)
      get_allocation_by(&block).each { |e| puts "#{e[0]} #{e[1]}" }
    end
  end
end