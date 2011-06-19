module AssetAllocationReporter
  class ExchangeFactory
    
    def self.parse_exchange_index(csv = 'data/exchanges.csv')
      
      exchange_index = {}
      
      # parse the static file of exchange details
      CSV.foreach(csv, :headers => true) do |row|
        exchange = Exchange.new(country = row[0], currency = row[1], name = row[2], google_symbol = row[3], yahoo_symbol = row[4])
        
        # index using Google and Yahoo! symbols
        exchange_index[exchange.google_symbol] = exchange
        exchange_index[exchange.yahoo_symbol] = exchange
      end
      
      return exchange_index
    end
  end
end