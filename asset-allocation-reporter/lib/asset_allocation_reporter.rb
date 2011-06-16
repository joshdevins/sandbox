# make all requires relative to this file
$:.unshift File.dirname(__FILE__)

# requires all Ruby files in given directory, relative to this file
def require_all(path)
  
  glob = File.join(File.dirname(__FILE__), path, '*.rb')
  
  Dir[glob].each do |f|
    require f
  end
end

# dependencies
# std lib
require 'ostruct'
 
# 3rd party
require 'open-uri'
require 'nokogiri'

# internal
require_all 'asset_allocation_reporter'

module AssertAllocationReporter
  VERSION = '1'
end
