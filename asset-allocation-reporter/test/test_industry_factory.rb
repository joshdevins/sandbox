require 'minitest/autorun'
require 'nokogiri'
require 'open-uri'

require 'asset_allocation_reporter'

class TestIndustryFactory < MiniTest::Unit::TestCase

  def test_parse_yahoo_industry_index
    
    f = File.open("test/resources/html/finance.yahoo.com/industry_index.html")
    html = Nokogiri::HTML(f)
    f.close
    
<<<<<<< HEAD
    industryIndex = AssetAllocationReporter::IndustryFactory.parse_yahoo_industry_index(html)
=======
    sectors = AssetAllocationReporter::IndustryFactory.parse_yahoo_industry_index(html)
>>>>>>> 12f905b66cbc2f32685f5d24b72af5bce6a691e1
  end
  
  def test_parse_yahoo_industry_index_live
    html = Nokogiri::HTML(open('http://biz.yahoo.com/ic/ind_index.html'))
<<<<<<< HEAD
    industryIndex = AssetAllocationReporter::IndustryFactory.parse_yahoo_industry_index(html)
=======
    sectors = AssetAllocationReporter::IndustryFactory.parse_yahoo_industry_index(html)
>>>>>>> 12f905b66cbc2f32685f5d24b72af5bce6a691e1
  end
end
