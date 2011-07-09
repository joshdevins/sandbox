module AssetAllocationReporter
  class Portfolio
  
    attr_reader :name
    attr_reader :currency
    attr_reader :stocks
    attr_reader :book_value
    attr_reader :holdings
  
    def initialize(name, currency, holdings)
      @name = name
      @currency = Money::Currency.new(currency)
      @holdings = holdings
      @book_value = holdings.reduce(Money.new(0, @currency)) { |memo, holding| memo + holding.book_value }
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
    
    def merge!(other)
      
      # validate same currency
      if (@currency != other.currency)
        raise "Currencies do not match"
      end
      
      # copy in new holdings
      @holdings = @holdings | other.holdings
      
      # merge holdings and create new holding object where two stocks are held in both portfolios
      other_holdings_by_stock = {}
      other.holdings.each { |holding| other_holdings_by_stock[holding.stock] = holding }
      @holdings.each do |holding|
        
        other_holding = other_holdings_by_stock[holding.stock]
        
        # merge holdings
        if other_holding != nil
          holding.merge!(other_holding)
        end
      end
      
      @book_value += other.book_value
    end
    
    def print_with_standard_allocations
      puts 'Current portfolio:'
      print
      puts

      puts 'Current portfolio allocations:'
      puts 'by symbol'
      print_allocation_by { |holding| holding.stock.symbol }
      puts
      puts 'by sector'
      print_allocation_by { |holding| holding.stock.industry.sector }
      puts
      puts 'by industry'
      print_allocation_by { |holding| holding.stock.industry }
      puts
      puts 'by market cap segment'
      print_allocation_by { |holding| holding.stock.market_cap_segment }
      puts
    end
    
    def print
      puts @name
      puts @currency
      @holdings.each { |holding| puts holding }
      puts "TOTAL #{book_value.currency}#{book_value.currency.symbol}#{book_value}"
    end
  end
end