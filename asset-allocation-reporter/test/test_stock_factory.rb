require 'minitest/autorun'

require 'asset_allocation_reporter'

class TestStockFactory < MiniTest::Unit::TestCase

  def test_parse_yahoo_profile_page
    
    f = File.open("test/resources/html/finance.yahoo.com/AAPL-profile.html")
    html = Nokogiri::HTML(f)
    f.close
    
    ids = parse_yahoo_profile_page(html)
  end
  
  def test_parse_yahoo_profile_page_live
    html = Nokogiri::HTML(open('http://finance.yahoo.com/q/pr?s=AAPL+Profile'))
    ids = parse_yahoo_profile_page(html)
  end
  
  def parse_yahoo_profile_page(html)
    
    industry_html = html.xpath('/html/body/div/div[3]/table[2]/tr[2]/td/table[2]/tr/td/table/tr[3]/td[2]/a')
    ids = AssetAllocationReporter::IndustryFactory.parse_sector_and_industry_ids_from_url(industry_html.attribute('href').value)
    
    assert_equal(8, ids.sector_id)
    assert_equal(811, ids.industry_id)
    
    return ids
  end
end
