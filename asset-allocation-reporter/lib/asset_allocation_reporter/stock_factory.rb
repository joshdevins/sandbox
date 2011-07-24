module AssetAllocationReporter
  class StockFactory

    def self.lookup_stocks(lookup)
      lookup_stocks_with(lookup, AssetAllocationReporter::EXCHANGE_INDEX, AssetAllocationReporter::INDUSTRY_INDEX)
    end
    
    def self.lookup_stocks_with(lookup, exchange_index, industry_index)

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
      stocks = {}
      csv.each_with_index do |row, index|

        # figure out the exchange if none was set
        exchange = lookup[index].exchange
        if (exchange == '')
          exchange = exchange_index[row[:exchange]]

          # verify exchnage was found
          if (exchange == nil)
            raise "Exchange returned from Yahoo! is not in the exchange index: #{row[:exchange]} #{lookup[index]}"
          end
        end

        # get the profile
        industry_id = parse_yahoo_profile_page_for_industry_id(lookup_symbols[index])

        # verify industry in index, if one was found
        if (industry_id != nil)
          
          industry = industry_index[industry_id]
          if (industry == nil)
            raise "Industry returned from Yahoo! is not in the industry index: #{industry_id}. Skipping stock: #{lookup[index]}"
          end
          
        else
          # use a nil object for industry/sector since it's not available
          industry = AssetAllocationReporter::NIL_INDUSTRY
        end

        # check to see if market cap is missing, get it from Google! if that's the case
        market_cap = parse_market_cap(row[:market_cap], exchange.currency)
        if (market_cap == nil)
          
          html = Nokogiri::HTML(open('http://www.google.ca/finance?q=TSE%3ADH'))
          market_cap_str = html.xpath('//span[@data-snapfield="market_cap"]')[0].parent.children[3].children[0].text
          market_cap = parse_market_cap(market_cap_str, exchange.currency)
        end

        # done
        stocks[lookup[index].internal_symbol] = Stock.new(exchange, lookup[index].symbol, row[:name],
            get_money(Float(row[:last_trade]), exchange.currency),
            market_cap, industry)
      end

      return stocks
    end
  
    def self.parse_market_cap(market_cap, currency)
      
      if market_cap == 'N/A'
        return nil
      end
      
      multiplier = 1000000 # millions by default
      if market_cap.end_with?('B')
        multiplier *= 1000 # bump up to billions
      elsif market_cap.end_with?('T')
        multiplier *= 1000 * 1000 # bump up to trillions
      elsif !market_cap.end_with?('M')
        raise "market cap is not in a valid format: #{market_cap}"
      end
      
      return get_money(Integer(Float(market_cap[0...-1]) * multiplier), currency)
    end
  
    def self.parse_yahoo_profile_page_for_industry_id(lookup_symbol)

      html = Nokogiri::HTML(open("http://finance.yahoo.com/q/pr?s=#{lookup_symbol}+Profile"))
      industry_html = html.xpath('/html/body/div/div[3]/table[2]/tr[2]/td/table[2]/tr/td/table/tr[3]/td[2]/a')
      
      # profile page doesn't exist or no data is found
      if (industry_html == nil || industry_html.empty?)
        return nil
      end
      
      sector_id, industry_id = IndustryFactory.parse_sector_and_industry_ids_from_url(industry_html.attribute('href').value)
      
      return industry_id
    end
    
    def self.get_money(units, currency)
      return Money.new(units * Money::Currency.find(currency).subunit_to_unit, currency)
    end
  end
end