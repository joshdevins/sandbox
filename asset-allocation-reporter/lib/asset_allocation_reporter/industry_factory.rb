module AssetAllocationReporter
  class IndustryFactory
    
    def self.parse_sector_and_industry_ids_from_url(url)
      industry_id = url.scan(/\/(\d{3}).html/).flatten[0]
      return Integer(industry_id[0]), Integer(industry_id)
    end
    
    def self.parse_yahoo_industry_index(html)

      xpath = "/html/body/table/tr/td/table[6]/tr/td/table[2]/tr[4]/td[%i]/table/tr/td/font"
      col1 = html.xpath(xpath % 1)
      col2 = html.xpath(xpath % 3)

      elements = col1 + col2
      elements = elements.map {|element| element.children[0]}

      industry_index = {}
      current_sector_str = nil
      current_sector = nil
      elements.each do |element|

        content = element.children[0].content.sub(/\n/, ' ')

        # is this a sector heading?
        if element.name == 'b'
          # create new sector in the map
          current_sector_str = content
          current_sector = nil

        elsif current_sector_str == nil
          raise "Current sector not set but needs to be: %s" % element.name

        elsif element.name != 'a'
          raise "Unexpected element encountered: %s" % element.name

        else
          # add industry by ID
          sector_id, industry_id = parse_sector_and_industry_ids_from_url(element.attributes['href'].value)
          
          # sensure there is only one sector instance for this ID
          if (current_sector == nil)
            current_sector = Sector.new(sector_id, current_sector_str)
          end
          
          industry_index[industry_id] = Industry.new(industry_id, content, current_sector)
        end
      end

      return industry_index
    end
  end
end
