module AssetAllocationReporter
  class Industry
    
    attr_reader :id
    attr_reader :name
    attr_reader :sector
    
    def initialize(id, name, sector)
      @id = id
      @name = name
      @sector = sector
    end
    
    def to_s
      return "#{id}:#{name} in #{sector}"
    end
    
    def to_str
      return name
    end
  end
end