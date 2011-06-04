require 'minitest/autorun'

class TestNokogiri < MiniTest::Unit::TestCase
  
  EXPECTED_HEADERS = ["Country", "Exchange Name", "Thomson Reuters Symbol", "Google Finance Symbol",
    "Yahoo! Finance Symbol", "Time Zone", "GMT ±", "Pre-Market", "Market Session", "Post-Market", "Currency (Code)"]
  
  def setup
    f = File.open("resources/html/wikinvest.com/List_of_Stock_Exchanges.html")
    @html = Nokogiri::HTML(f)
    f.close
  end

  def test_that_parsing_works
    # generic XPath to tables with codes
    table_xpath = '/html/body/div/div[2]/div[3]/div/div[3]/div/div/table[%i]/tbody'
    3..7.each do |i|
      @html.xpath(table_xpath % i)
      
      # verify the headers
      headers = tbody.xpath('tr/td/b').map {|e| e.child.content}
      assert_equal(EXPECTED_HEADERS, headers)
      
      rows = tbody.xpath('tr')
      rows.shift
      rows = rows.map {|e| e.children}
      rows.each do |row|
        columns = row.children
        
        country = columns[0].child.content
        exchange_name = columns[1].child.content
        thomson_reuters = columns[2].content
        google = columns[3].content
        yahoo = columns[4].content
        
        if columns[9].child != nil
          country_code = columns[9].child.content
        end
      end
    end
    
  end
end
