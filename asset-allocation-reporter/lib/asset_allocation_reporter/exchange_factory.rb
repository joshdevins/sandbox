module AssetAllocationReporter
  class ExchangeFactory
    
    def self.parse_exchange_index(csv = 'data/exchanges.csv')
      
      exchange_index = {}
      
      headers = [:country, :currency, :name, :google_symbol, :yahoo_symbol, :yahoo_ws_symbol]
      
      # parse the static file of exchange details
      CSV.foreach(csv, :headers => headers) do |row|
        exchange = Exchange.new(row[:country], row[:currency], row[:name], row[:google_symbol], row[:yahoo_symbol], row[:yahoo_ws_symbol])
        
        # index using Google and Yahoo! symbols
        exchange_index[exchange.google_symbol] = exchange
        exchange_index[exchange.yahoo_symbol] = exchange
        exchange_index[exchange.yahoo_ws_symbol] = exchange
      end
      
      return exchange_index
    end
  end
end