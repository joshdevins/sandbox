module AssetAllocationReporter
  class Sector
    
    attr_reader :id
    attr_reader :name
    
    def initialize(id, name)
      @id = id
      @name = name
      
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
      return @id.hash
    end
    
    def to_s
      return "#{id} #{name}"
    end
    
    def to_str
      return name
    end
  end
end