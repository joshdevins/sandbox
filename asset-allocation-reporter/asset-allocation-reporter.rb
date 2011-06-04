#!/usr/bin/env ruby

require 'open-uri'

class Exchange
  
  @@systems = {
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

class Stock
  
  attr_reader :exchange
  attr_reader :ticker
  attr_reader :name
  attr_reader :currency
  attr_reader :market_cap
  attr_reader :sector
  attr_reader :industry
  
  def initialize(exchange, ticker, name, currency, market_cap, sector = "", industry = "")
    @exchange = exchange
    @ticker = ticker
    @name = name
    @currency = currency
    @market_cap = market_cap
    @sector = sector
    @industry = industry
  end
  
  def to_s
    "#{exchange}:#{ticker}, name=#{name}, currency=#{currency}, market_cap=#{market_cap}M, sector=#{sector}, industry=#{industry}"
  end
  
  # latest (net, gross) revenue by geography
end

class AssetAllocationReporter
  
  def initialize(stocks)
    @stocks = stocks
  end
  
  def print
    @stocks.each { |stock| puts stock }
  end
  
end

if __FILE__ == $0
  
  aapl = Stock.new("NASDAQ", "AAPL", "Apple Inc.", "USD", 310270, "Technology", "Computer Hardware")
  amzn = Stock.new("NASDAQ", "AMZN", "Amazon.com, Inc.", "USD", 88150, "Services", "Retail (Catalog and Mail Order)")
  
  current_portfolio = AssetAllocationReporter.new([aapl, amzn])
  
  puts "Current portfolio:"
  current_portfolio.print
end
