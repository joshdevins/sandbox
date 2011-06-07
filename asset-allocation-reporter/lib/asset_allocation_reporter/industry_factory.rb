module AssetAllocationReporter
  class IndustryFactory
    
    def self.parse_yahoo_industry_index(html)

      xpath = "/html/body/table/tbody/tr/td/table[6]/tbody/tr/td/table[2]/tbody/tr[4]/td[%i]/table/tbody/tr/td/font"
      col1 = html.xpath(xpath % 1)
      col2 = html.xpath(xpath % 3)

      elements = col1 + col2
      elements = elements.map {|element| element.children[0]}

      sectors = {}
      current_sector = nil
      elements.each do |element|

        content = element.children[0].content.sub(/\n/, ' ')

        # is this a sector heading?
        if element.name == 'b'
          # create new sector in the map
          current_sector = content
          sectors[current_sector] = Array.new

        elsif current_sector == nil
          raise "Current sector not set but needs to be: %s" % element.name

        elsif element.name != 'a'
          raise "Unexpected element encountered: %s" % element.name

        else
          # add industry to the sector
          sectors[current_sector] << content
        end
      end
      
      return sectors
    end
  end
end
