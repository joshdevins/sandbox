module AssetAllocationReporter
  class ExchangeFactory
    
    def self.parse_exchange_index(csv = 'data/exchanges.csv')
      
      exchange_index = {}
      
      headers = [:country, :currency, :name, :google_symbol, :yahoo_symbol, :yahoo_ws_symbol]
      
      # parse the static file of exchange details
      csv = CSV.read(csv, { headers: headers, return_headers: false, skip_blanks: true })
      csv.delete(0) # get rid of headers
      csv.each do |row|
        
        if !Money::Currency.find(row[:currency])
          raise "Could not find currency: #{row[:currency]}"
        end
        
        exchange = Exchange.new(row[:country], Money::Currency.find(row[:currency]), row[:name], row[:google_symbol], row[:yahoo_symbol], row[:yahoo_ws_symbol])
        
        # index using Google and Yahoo! symbols
        exchange_index[exchange.google_symbol] = exchange
        exchange_index[exchange.yahoo_symbol] = exchange
        exchange_index[exchange.yahoo_ws_symbol] = exchange
      end
      
      return exchange_index
    end
  end
end