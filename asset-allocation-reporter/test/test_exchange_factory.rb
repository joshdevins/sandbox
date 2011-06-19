require 'minitest/autorun'

require 'asset_allocation_reporter'

class TestExchangeFactory < MiniTest::Unit::TestCase
  
  def test_parse_exchange_index
    exchange_index = AssetAllocationReporter::ExchangeFactory.parse_exchange_index('lib/asset_allocation_reporter/data/exchanges.csv')

    refute_nil(exchange_index)
    
    lon = exchange_index['LON']
    l = exchange_index['L']
    refute_nil(lon)
    refute_nil(l)
    
    assert_equal(lon, l)
    assert_equal('United Kingdom', lon.country)
    assert_equal('GBP', lon.currency)
    assert_equal('London Stock Exchange', lon.name)
  end
end
