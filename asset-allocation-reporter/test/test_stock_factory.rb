require 'minitest/autorun'

require 'asset_allocation_reporter'

class TestStockFactory < MiniTest::Unit::TestCase

  def test_parse_yahoo_profile_page
    
    f = File.open("test/resources/html/finance.yahoo.com/AAPL-profile.html")
    html = Nokogiri::HTML(f)
    f.close
    
    industry_html = html.xpath('/html/body/div/div[3]/table[2]/tbody/tr[2]/td/table[2]/tbody/tr/td/table/tbody/tr[3]/td[2]/a')
    ids = AssetAllocationReporter::IndustryFactory.parse_sector_and_industry_ids_from_url(industry_html.attribute('href').value)
    
    assert_equal(8, ids.sector_id)
    assert_equal(811, ids.industry_id)
  end
  
  def test_parse_yahoo_profile_page_live
  end
end
