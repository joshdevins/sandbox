#!/usr/bin/env ruby

# dependencies
# make all requires relative to lib
$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])
require 'asset_allocation_reporter'

module AssetAllocationReporter
  
  # stocks
  lookup = [
    LookupStock.new('AMZN'),
    LookupStock.new('DIS'),
    LookupStock.new('GOOG'),

    LookupStock.new('AAPL'),
    LookupStock.new('BRK-B'),
    LookupStock.new('CWB', 'TSE'),
    LookupStock.new('DH', 'TSE'),
    LookupStock.new('JNJ'),
    LookupStock.new('PG'),
    LookupStock.new('TRI', 'TSE'),
    ]

  stocks = StockFactory.lookup_stocks(lookup)

  # portfolios
  itrade_non_registered_holdings = [
    Holding.new(stocks[0], 21, :usd),
    Holding.new(stocks[1], 39, :usd),
    Holding.new(stocks[2], 4, :usd),
    ]
  itrade_non_registered = Portfolio.new("CAD$ non-registered (iTrade)", :cad, itrade_non_registered_holdings)
  itrade_non_registered.print_with_standard_allocations()

  itrade_registered_holdings = [
    Holding.new(stocks[3], 11, :usd),
    Holding.new(stocks[4], 50, :usd),
    Holding.new(stocks[5], 104, :cad),
    Holding.new(stocks[6], 135, :cad),
    Holding.new(stocks[7], 34, :usd),
    Holding.new(stocks[8], 32, :usd),
    Holding.new(stocks[9], 64, :cad),
    ]
  itrade_registered = Portfolio.new("CAD$ registered (iTrade)", :cad, itrade_registered_holdings)
  itrade_registered.print_with_standard_allocations()

  # overall
  overall = Portfolio.new("all holdings (CAD$ normalized)", :cad, [])
  overall.merge!(itrade_non_registered)
  overall.merge!(itrade_registered)
  overall.print_with_standard_allocations()
end