#!/usr/bin/env ruby

# dependencies
# make all requires relative to lib
$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])
require 'asset_allocation_reporter'

module AssetAllocationReporter
  
  # stocks
  lookup = [
    LookupStock.new('AAPL',),
    LookupStock.new('GOOG'),
    LookupStock.new('TRI', 'TSE')]

  stocks = StockFactory.lookup_stocks(lookup)

  # portfolios
  current_portfolio_holdings = [
    Holding.new(stocks[0], 10, :cad),
    Holding.new(stocks[1], 10, :cad),
    Holding.new(stocks[2], 100, :cad)]
  current_portfolio = Portfolio.new("CAD$ non-reg'd", :cad, current_portfolio_holdings)
  current_portfolio.print_with_standard_allocations()

end
