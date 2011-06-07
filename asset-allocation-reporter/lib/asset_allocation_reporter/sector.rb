module AssetAllocationReporter
  class Sector
    
    attr_reader :id
    attr_reader :name
    
    def initialize(id, name)
      @id = id
      @name = name
    end
    
    def to_s
      return "#{id} #{name}"
    end
    
    def to_str
      return name
    end
  end
end