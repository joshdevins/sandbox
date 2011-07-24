module AssetAllocationReporter
  class Holding
    
    attr_reader :stock
    attr_reader :shares_owned
    
    def initialize(stock, shares_owned)
      
      if (stock == nil)
        raise 'Stock is nil'
      end
      
      if (stock.last_trade == nil)
        raise "Last trade is nil for stock: #{stock.name}"
      end
      
      @stock = stock
      @shares_owned = shares_owned
    end
    
    def book_value
      return stock.last_trade * @shares_owned
    end
    
    def merge!(other)
      @shares_owned += other.shares_owned
    end
    
    def ==(other)
      return true if self.equal?(other)
      return false unless other.class == self.class
      return false unless other.instance_variables == self.instance_variables
      
      return @stock == other.stock && @shares_owned == other.shares_owned
    end
  
    def eql?(other)
      return self == other
    end
  
    def hash
      return to_s.hash
    end
    
    def to_s
      return "#{stock} [shares=#{shares_owned} book_value=#{book_value.currency}#{book_value.currency.symbol}#{book_value}]"
    end
    
    def to_str
      return stock.to_str
    end
  end
end