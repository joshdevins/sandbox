require 'minitest/autorun'
require 'nokogiri'
require 'open-uri'

require 'asset_allocation_reporter'

class TestNokogiri < MiniTest::Unit::TestCase

  def test_parse_yahoo_industry_index
    
    f = File.open("test/resources/html/finance.yahoo.com/industry_index.html")
    html = Nokogiri::HTML(f)
    f.close
    
    sectors = AssetAllocationReporter::IndustryFactory.parse_yahoo_industry_index(html)
  end
  
  def test_parse_yahoo_industry_index_live
    html = Nokogiri::HTML(open('http://biz.yahoo.com/ic/ind_index.html'))
    sectors = AssetAllocationReporter::IndustryFactory.parse_yahoo_industry_index(html)
  end
end
