module AssetAllocationReporter
  class AllocationSegment
    
    attr_reader :holdings
    attr_reader :book_value
    attr_reader :percentage
    
    def initialize(portfolio_book_value, holdings)
      
      # stash the holdings mostly for printing purposes
      @holdings = holdings
      
      # calculate the book_value of these holdings
      @book_value = holdings.reduce(Money.new(0, portfolio_book_value.currency)) do |memo, holding|
        memo + holding.book_value
      end
      
      # calculate the percentage of the portfolio's total book value that this segment represents
      @percentage = Integer(((100 / Float(portfolio_book_value.cents)) * @book_value.cents).round(0))
    end
    
    def to_s
      "#{percentage}% #{book_value.currency}#{book_value.currency.symbol}#{book_value}"
    end
  end
end