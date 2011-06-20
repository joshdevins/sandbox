module AssetAllocationReporter
  class StockFactory
    
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
        last_trade: 'l1',
        market_cap: 'j1',
      }

      conn = open("http://finance.yahoo.com/d/quotes.csv?s=#{URI.escape(symbols_str)}&f=#{columns.values.join}")
      csv = CSV.parse(conn.read, :headers => columns.keys)

      # build full stock objects
      stocks = []
      csv.each_with_index do |row, index|

        # figure out the exchange if none was set
        exchange = lookup[index].exchange
        if (exchange == '')
          exchange = exchange_index[row[:exchange]]

          # verify exchnage was found
          if (exchange == nil)
            raise "Exchange returned from Yahoo! is not in the exchange index: #{row[:exchange]}. Skipping stock: #{lookup[index]}"
          end
        end

        # get the profile
        industry_id = parse_yahoo_profile_page_for_industry_id(lookup_symbols[index])

        # verify industry in index
        industry = industry_index[industry_id]
        if (industry == nil)
          raise "Industry returned from Yahoo! is not in the industry index: #{industry_id}. Skipping stock: #{lookup[index]}"
        end

        # done
        stocks << Stock.new(exchange, lookup[index].symbol, row[:name], row[:last_trade], parse_market_cap(row[:market_cap], exchange.currency), industry)
      end

      return stocks
    end
  
    def self.parse_market_cap(market_cap, currency)
      
      if !Money::Currency.find(currency)
        raise "Could not find currency: #{currency}"
      end
      
      multiplier = 1000000 # millions by default
      if market_cap.end_with?('B')
        multiplier *= 1000 # bump up to billions
      elsif market_cap.end_with?('T')
        multiplier *= 1000 * 1000 # bump up to trillions
      elsif !market_cap.end_with?('M')
        raise "market cap is not in a valid format: #{market_cap}"
      end
      
      dollars = Integer(Float(market_cap[0...-1]) * multiplier)
      return Money.new(dollars * Money::Currency.find(currency).subunit_to_unit, currency)
    end
  
    def self.parse_yahoo_profile_page_for_industry_id(lookup_symbol)

      html = Nokogiri::HTML(open("http://finance.yahoo.com/q/pr?s=#{lookup_symbol}+Profile"))
      industry_html = html.xpath('/html/body/div/div[3]/table[2]/tr[2]/td/table[2]/tr/td/table/tr[3]/td[2]/a')
      sector_id, industry_id = IndustryFactory.parse_sector_and_industry_ids_from_url(industry_html.attribute('href').value)
      
      return industry_id
    end
  end
end