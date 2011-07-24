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
require 'open-uri'
require 'csv'

# 3rd party
require 'nokogiri'
require 'money'
require 'money/bank/google_currency'

# internal
require_all 'asset_allocation_reporter'

module AssetAllocationReporter
  VERSION = '1'
  
  NIL_CDN_EXCHANGE = Exchange.new('CDN', :cad, 'NIL CAD$', 'n/a', 'n/a', 'n/a')
  NIL_USA_EXCHANGE = Exchange.new('USA', :usd, 'NIL USD$', 'n/a', 'n/a', 'n/a')
  NIL_SECTOR = Sector.new(0, 'n/a')
  NIL_INDUSTRY = Industry.new(0, 'n/a', NIL_SECTOR)
  
  # set default bank to instance of GoogleCurrency
  Money.default_bank = Money::Bank::GoogleCurrency.new
    
  # load exchange and industry indices
  EXCHANGE_INDEX = ExchangeFactory.parse_exchange_index('lib/asset_allocation_reporter/data/exchanges.csv')
  INDUSTRY_INDEX = IndustryFactory.parse_yahoo_industry_index(Nokogiri::HTML(open('http://biz.yahoo.com/ic/ind_index.html')))
end
