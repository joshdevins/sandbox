#!/usr/bin/env ruby

class Stock
  
  attr_reader :name
  attr_reader :ticker
  attr_reader :currency
  attr_reader :marketCapInMillions
  attr_reader :sector
  attr_reader :industry
  
  def initialize(name, exchange, ticker, currency, marketCap, sector = "", industry = "")
    @name = name
    @ticker = ticker
    @currency = currency
    @marketCap = marketCap
    @sector = sector
    @industry = industry 
  end
  
end

class AssetAllocationReporter
  
  def initialize(stocks)
    @stocks = stocks
  end
  
end

if __FILE__ == $0
  
  aapl = Stock.new("Apple Inc.", "NASDAQ", "AAPL", "USD", 1000, "Technology", "Computer Hardware")
  
  currentPortfolio = AssetAllocationReporter.new([aapl])
end
