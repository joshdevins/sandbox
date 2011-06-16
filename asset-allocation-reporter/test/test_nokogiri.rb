require 'minitest/autorun'

require 'asset_allocation_reporter'

class TestNokogiri < MiniTest::Unit::TestCase

  def test_parse_yahoo_profile_page
    
    f = File.open("test/resources/html/finance.yahoo.com/AAPL-profile.html")
    html = Nokogiri::HTML(f)
    f.close
    
    industry_html = html.xpath('/html/body/div/div[3]/table[2]/tbody/tr[2]/td/table[2]/tbody/tr/td/table/tbody/tr[3]/td[2]/a')
    industry_id_str = industry_html.attribute('href').value.split('/')[-1][0..2]
    industry_id = Integer(industry_id_str)
    sector_id = Integer(industry_id_str[0])
    
    #assert_equals(811, industry_id)
    #assert_equals(8, sector_id)
  end
end
