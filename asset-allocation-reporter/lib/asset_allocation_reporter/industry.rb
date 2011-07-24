module AssetAllocationReporter
  class Industry
    
    attr_reader :id
    attr_reader :name
    attr_reader :sector
    
    def initialize(id, name, sector)
      @id = id
      @name = name
      @sector = sector
      
      self.freeze
    end
    
    def ==(other)
      return true if self.equal?(other)
      return false unless other.class == self.class
      return false unless other.instance_variables == self.instance_variables
      
      return @id == other.id
    end
  
    def eql?(other)
      return self == other
    end
  
    def hash
      return id.hash
    end
    
    def to_s
      return "#{name} (#{sector})"
    end
    
    def to_str
      return name
    end
    
    def self.nil_object
      return Industry.the_nil_object
    end
  end
end