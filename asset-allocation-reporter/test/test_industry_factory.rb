require 'minitest/autorun'

require 'asset_allocation_reporter'

class TestIndustryFactory < MiniTest::Unit::TestCase

  def test_parse_sector_and_industry_ids_from_url
    url = 'http://biz.yahoo.com/ic/811.html'
    ids = AssetAllocationReporter::IndustryFactory.parse_sector_and_industry_ids_from_url(url)
    
    refute_nil(ids)
    assert_equal(8, ids.sector_id)
    assert_equal(811, ids.industry_id)
  end

  def test_parse_yahoo_industry_index
    
    f = File.open("test/resources/html/finance.yahoo.com/industry_index.html")
    html = Nokogiri::HTML(f)
    f.close
    
    validate_industry_index(html)
  end
  
  def test_parse_yahoo_industry_index_live
    html = Nokogiri::HTML(open('http://biz.yahoo.com/ic/ind_index.html'))
    validate_industry_index(html)
  end
  
  def validate_industry_index(html)
    industry_index = AssetAllocationReporter::IndustryFactory.parse_yahoo_industry_index(html)
    refute_nil(industry_index)
    
    industry = industry_index[112]
    refute_nil(industry)
    
    sector = industry.sector
    refute_nil(sector)
    
    assert_equal(112, industry.id)
    assert_equal('Agricultural Chemicals', industry.name)
    
    assert_equal(1, sector.id)
    assert_equal('Basic Materials', sector.name)
  end
end
