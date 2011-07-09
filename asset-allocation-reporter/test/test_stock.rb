require 'minitest/autorun'

require 'asset_allocation_reporter'

module AssetAllocationReporter
  class TestStock < MiniTest::Unit::TestCase
    
    def test_determine_market_cap_segments
      
      # mega	  $200B +
      # large  $5B - $200B
      # mid    $1B - $5B
      # small  $300M - $1B
      # micro  $50M - $300M
      # nano   $0 - $50M
      
      assert_equal(:mega, Stock.determine_market_cap_segment(Money.new(500 * 1000 * 1000 * 1000, "CAD"))) # 500B
      assert_equal(:large, Stock.determine_market_cap_segment(Money.new(100 * 1000 * 1000 * 1000, "CAD"))) # 100B
      assert_equal(:mid, Stock.determine_market_cap_segment(Money.new(3 * 1000 * 1000 * 1000, "CAD"))) # 3B
      assert_equal(:small, Stock.determine_market_cap_segment(Money.new(300 * 1000 * 1000, "CAD"))) # 300M
      assert_equal(:micro, Stock.determine_market_cap_segment(Money.new(100 * 1000 * 1000, "CAD"))) # 100M
      assert_equal(:nano, Stock.determine_market_cap_segment(Money.new(100 * 1000, "CAD"))) # 100K
    end
  end
end