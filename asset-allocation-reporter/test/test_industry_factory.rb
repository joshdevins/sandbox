require 'minitest/autorun'
require 'nokogiri'
require 'open-uri'

require 'asset_allocation_reporter'

class TestIndustryFactory < MiniTest::Unit::TestCase

  def test_parse_yahoo_industry_index
    
    f = File.open("test/resources/html/finance.yahoo.com/industry_index.html")
    html = Nokogiri::HTML(f)
    f.close
    
    industryIndex = AssetAllocationReporter::IndustryFactory.parse_yahoo_industry_index(html)
  end
  
  def test_parse_yahoo_industry_index_live
    html = Nokogiri::HTML(open('http://biz.yahoo.com/ic/ind_index.html'))
    industryIndex = AssetAllocationReporter::IndustryFactory.parse_yahoo_industry_index(html)
  end
end
