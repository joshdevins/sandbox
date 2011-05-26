#!/usr/bin/env ruby

class Stock
  
  attr_reader :exchange
  attr_reader :ticker
  attr_reader :name
  attr_reader :currency
  attr_reader :marketCap
  attr_reader :sector
  attr_reader :industry
  
  def initialize(exchange, ticker, name, currency, marketCap, sector = "", industry = "")
    @exchange = exchange
    @ticker = ticker
    @name = name
    @currency = currency
    @marketCap = marketCap
    @sector = sector
    @industry = industry
  end
  
  def asString
    return "#{exchange}:#{ticker}\tname=#{name}\tcurrency=#{currency}\tmarketCap=#{marketCap}M\tsector=#{sector}\tindustry=#{industry}"
  end
  
  # latest (net, gross) revenue by geography
end

class AssetAllocationReporter
  
  def initialize(stocks)
    @stocks = stocks
  end
  
  def print
    @stocks.each do |stock|
      puts stock.asString
    end
  end
  
end

if __FILE__ == $0
  
  aapl = Stock.new("NASDAQ", "AAPL", "Apple Inc.", "USD", 310270, "Technology", "Computer Hardware")
  amzn = Stock.new("NASDAQ", "AMZN", "Amazon.com, Inc.", "USD", 88150, "Services", "Retail (Catalog and Mail Order)")
  
  currentPortfolio = AssetAllocationReporter.new([aapl, amzn])
  
  puts "Current portfolio:"
  currentPortfolio.print
end
