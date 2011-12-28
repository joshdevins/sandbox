#!/usr/bin/env ruby

require 'bundler'
Bundler.setup

# dependencies
# make all requires relative to lib
$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])
require 'asset_allocation_reporter'

module AssetAllocationReporter
  
  require '~/Dropbox/Documents/personal/banking/asset-allocation/asset_allocation_reporter'
end
