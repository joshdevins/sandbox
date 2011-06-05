module AssetAllocationReporter
  class Sector
    
    attr_reader :id
    attr_reader :name
    attr_reader :industries
    
    def initialize(id, name, industries)
      @id = id
      @name = name
      @industries = industries
    end
    
    def to_s
      return "#{id} #{name}"
    end
    
    def to_str
      return name
    end
  end
end