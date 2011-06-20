module AssetAllocationReporter
  class StockFactory
    
    public
    
      def self.lookup_stocks(lookup, exchange_index, industry_index)

        # lookup proper Yahoo! symbol
        lookup.each do |s|

          # no exchange provided, just have to try without one
          if s.exchange == nil || s.exchange.empty?
            s.exchange = ''
            next
          end

          # exchange provided
          exchange = exchange_index[s.exchange]
          if (exchange)
            s.exchange = exchange
          else
            puts "Could not find exchange with symbol: #{s.exchange}"
            s.exchange = nil
          end
        end

        # remove any nil items, unkown exchanges
        lookup = lookup.keep_if {|s| s.exchange != nil}

        # convert to lookup symbols
        lookup_symbols = lookup.map { |s| s.get_lookup_symbol }
        symbols_str = lookup_symbols.join('+')

        columns = {
          exchange: 'x',
          name: 'n',
          market_cap: 'j1',
        }

        stocks = []
        conn = open("http://finance.yahoo.com/d/quotes.csv?s=#{URI.escape(symbols_str)}&f=#{columns.values.join}")

        csv = CSV.parse(conn.read, :headers => columns.keys)
        csv.each_with_index do |row, index|

          # figure out the exchange if none was set
          exchange = lookup[index].exchange
          if (exchange == '')
            exchange = exchange_index[row[:exchange]]

            # verify exchnage was found
            if (exchange == nil)
              puts "Exchange returned from Yahoo! is not in the exchange index: #{row[:exchange]}. Skipping stock: #{lookup[index]}"
              next
            end
          end

          # get the profile
          profile_html = Nokogiri::HTML(open("http://finance.yahoo.com/q/pr?s=#{lookup_symbols[index]}+Profile"))
          sector_id, industry_id = parse_yahoo_profile_page(profile_html)

          # verify industry in index
          industry = industry_index[industry_id]
          if (industry == nil)
            puts "Industry returned from Yahoo! is not in the industry index: #{industry_id}. Skipping stock: #{lookup[index]}"
            next
          end

          # done
          stocks << AssetAllocationReporter::Stock.new(exchange, lookup[index].symbol, row[:name], row[:market_cap], industry)
        end

        return stocks
      end

    private
    
      def self.parse_yahoo_profile_page(html)

        industry_html = html.xpath('/html/body/div/div[3]/table[2]/tr[2]/td/table[2]/tr/td/table/tr[3]/td[2]/a')
        return AssetAllocationReporter::IndustryFactory.parse_sector_and_industry_ids_from_url(industry_html.attribute('href').value)
      end
  end
end