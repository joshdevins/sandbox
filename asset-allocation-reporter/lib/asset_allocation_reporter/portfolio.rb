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
    
    def get_allocation_by_symbol
      return get_allocation_by { |holding| holding.stock.symbol }
    end

    def get_allocation_by_sector
      return get_allocation_by { |holding| holding.stock.industry.sector }
    end
    
    def get_allocation_by_industry
      return get_allocation_by { |holding| holding.stock.industry }
    end
    
    def get_allocation_by_market_cap_segment
      return get_allocation_by { |holding| holding.stock.market_cap_segment }
    end
    
    def merge!(other)
      
      # validate same currency
      if (@currency != other.currency)
        raise "Currencies do not match"
      end
      
      # find stocks that need to be merged and those that can just be copied over directly
      these_stocks = @holdings.collect { |h| h.stock }
      other_stocks = other.holdings.collect { |h| h.stock }
      
      new_stocks = other_stocks - these_stocks # difference
      new_holdings = other.holdings.select { |h| new_stocks.include?(h.stock) }
      
      merge_stocks = other_stocks & these_stocks # intersection
      merge_holdings = other.holdings.select { |h| merge_stocks.include?(h.stock) }
      
      # add new holdings
      @holdings = @holdings | new_holdings
      
      # merge same stocks into new holdings
      merge_holdings_by_stock = {}
      merge_holdings.each { |holding| merge_holdings_by_stock[holding.stock] = holding }
      @holdings.each do |holding|
        
        merge_holding = merge_holdings_by_stock[holding.stock]
        
        # merge holdings
        if merge_holding != nil
          holding.merge!(merge_holding)
        end
      end
      
      @book_value += other.book_value
    end
    
    def print_with_standard_allocations
      puts "Portfolio:"
      print
      puts
      puts 'by symbol'
      Portfolio.print_allocation(get_allocation_by_symbol)
      puts
      puts 'by sector'
      Portfolio.print_allocation(get_allocation_by_sector)
      puts
      puts 'by industry'
      Portfolio.print_allocation(get_allocation_by_industry)
      puts
      puts 'by market cap segment'
      Portfolio.print_allocation(get_allocation_by_market_cap_segment)
      puts
    end
    
    def print
      puts @name
      puts @currency
      @holdings.each { |holding| puts holding }
      puts "TOTAL #{book_value.currency}#{book_value.currency.symbol}#{book_value}"
    end
    
    def self.print_allocation(allocation)
      allocation.each { |e| puts "#{e[1].percentage}% #{e[0]} #{e[1].book_value.currency}#{e[1].book_value.currency.symbol}#{e[1].book_value}" }
    end
    
    def self.print_allocation_by(&block)
      print_allocation(get_allocation_by(&block))
    end
  end
end