require 'minitest/autorun'

require 'asset_allocation_reporter'

module AssetAllocationReporter
  class TestExchangeFactory < MiniTest::Unit::TestCase
  
    def test_parse_exchange_index
      exchange_index = ExchangeFactory.parse_exchange_index('lib/asset_allocation_reporter/data/exchanges.csv')

      refute_nil(exchange_index)
    
      lon = exchange_index['LON']
      l = exchange_index['L']
      refute_nil(lon)
      refute_nil(l)
    
      assert_equal(lon, l)
      assert_equal('United Kingdom', lon.country)
      assert_equal('GBP', lon.currency.iso_code)
      assert_equal('London Stock Exchange', lon.name)
    
      # empty?
      assert_nil(exchange_index[''])
    
      # ws name
      assert_equal(exchange_index['NASDAQ'], exchange_index['NasdaqNM'])
    end
  end
end