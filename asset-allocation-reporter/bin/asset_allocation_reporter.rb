#!/usr/bin/env ruby

# dependencies
# make all requires relative to lib
$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])
require 'asset_allocation_reporter'

# sectors
sectors_html = Nokogiri::HTML(open('http://biz.yahoo.com/ic/ind_index.html'))
sectors = AssetAllocationReporter::IndustryFactory.parse_yahoo_industry_index(sectors_html)

puts "Sectors:"
puts sectors
puts

# stocks
aapl = AssetAllocationReporter::Stock.new("NASDAQ", "AAPL", "Apple Inc.", "USD", 310270, "Technology", "Computer Hardware")
amzn = AssetAllocationReporter::Stock.new("NASDAQ", "AMZN", "Amazon.com, Inc.", "USD", 88150, "Services", "Retail (Catalog and Mail Order)")

# portfolios
current_portfolio = AssetAllocationReporter::Portfolio.new([aapl, amzn])

puts "Current portfolio:"
current_portfolio.print
puts
