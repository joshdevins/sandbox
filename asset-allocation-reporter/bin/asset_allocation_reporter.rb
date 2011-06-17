#!/usr/bin/env ruby

# dependencies
# make all requires relative to lib
$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])
require 'asset_allocation_reporter'

# exchanges

# industries
industry_index_html = Nokogiri::HTML(open('http://biz.yahoo.com/ic/ind_index.html'))
industry_index = AssetAllocationReporter::IndustryFactory.parse_yahoo_industry_index(industry_index_html)

# stocks

# portfolios
#current_portfolio = AssetAllocationReporter::Portfolio.new([aapl, amzn])

puts "Current portfolio:"
current_portfolio.print
puts
