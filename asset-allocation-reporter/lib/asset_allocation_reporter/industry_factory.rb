module AssetAllocationReporter
  class IndustryFactory
    
    def self.parse_yahoo_industry_index(html)

      xpath = "/html/body/table/tr/td/table[6]/tr/td/table[2]/tr[4]/td[%i]/table/tr/td/font"
      col1 = html.xpath(xpath % 1)
      col2 = html.xpath(xpath % 3)

      elements = col1 + col2
      elements = elements.map {|element| element.children[0]}

      industryIndex = {}
      current_sector = nil
      elements.each do |element|

        content = element.children[0].content.sub(/\n/, ' ')

        # is this a sector heading?
        if element.name == 'b'
          # create new sector in the map
          current_sector = content

        elsif current_sector == nil
          raise "Current sector not set but needs to be: %s" % element.name

        elsif element.name != 'a'
          raise "Unexpected element encountered: %s" % element.name

        else
          # add industry by ID
          industryId = element.attributes['href'].value.scan(/\/(\d{3}).html/).flatten[0]
          sectorId = industryId[0]
          
          sector = Sector.new(Integer(sectorId), current_sector)
          industryIndex[industryId] = Industry.new(Integer(industryId), content, sector)
        end
      end

      return industryIndex
    end
  end
end
