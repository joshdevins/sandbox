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

  puts "Current portfolio:"
  current_portfolio.print
  puts

  puts "Current portfolio allocations:"
  puts "by symbol"
  current_portfolio.print_allocation_by { |holding| holding.stock.symbol }
  puts
  puts "by sector"
  current_portfolio.print_allocation_by { |holding| holding.stock.industry.sector }
  puts
  puts "by industry"
  current_portfolio.print_allocation_by { |holding| holding.stock.industry }
  puts
  puts "by market cap segment"
  current_portfolio.print_allocation_by { |holding| holding.stock.market_cap_segment }
  puts
end
