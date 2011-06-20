#!/usr/bin/env ruby

# dependencies
# make all requires relative to lib
$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])
require 'asset_allocation_reporter'

# load exchange index
exchange_index = AssetAllocationReporter::ExchangeFactory.parse_exchange_index('lib/asset_allocation_reporter/data/exchanges.csv')

# load industry index
industry_index_html = Nokogiri::HTML(open('http://biz.yahoo.com/ic/ind_index.html'))
industry_index = AssetAllocationReporter::IndustryFactory.parse_yahoo_industry_index(industry_index_html)

# stocks
lookup = [AssetAllocationReporter::LookupStock.new('AAPL',),
          AssetAllocationReporter::LookupStock.new('GOOG'),
          AssetAllocationReporter::LookupStock.new('TRI', 'TSE')]

stocks = AssetAllocationReporter::StockFactory.lookup_stocks(lookup, exchange_index, industry_index)

# portfolios
current_portfolio = AssetAllocationReporter::Portfolio.new(stocks)

puts "Current portfolio:"
current_portfolio.print
puts
