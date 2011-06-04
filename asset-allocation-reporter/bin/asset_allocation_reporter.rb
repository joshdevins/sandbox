#!/usr/bin/env ruby

# make all requires relative to lib
$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

# dependencies
require 'asset_allocation_reporter'

aapl = Stock.new("NASDAQ", "AAPL", "Apple Inc.", "USD", 310270, "Technology", "Computer Hardware")
amzn = Stock.new("NASDAQ", "AMZN", "Amazon.com, Inc.", "USD", 88150, "Services", "Retail (Catalog and Mail Order)")

current_portfolio = AssetAllocationReporter::Portfolio.new([aapl, amzn])

puts "Current portfolio:"
current_portfolio.print
