#
#
module BTree
  class Node
    def initialize( tree = nil )
      @tree = tree
      @values = []
    end

    def empty?
      @values.empty?
    end
    
    def add_value( value )
      pos = 0

      while value > @values[ pos ]
        pos += 1
        break if pos >= @values.size
      end unless @values.empty?

      if pos >= @values.size
        @values << value
      else
        @values.insert( pos, value )
      end

      self.elements_per_node
      leaf?
    end

    attr_reader :values
    attr_reader :tree

  protected
    #
    def elements_per_node
      @tree.elements_per_node if @tree
    end

    #
    def leaf?
      true
    end
  end
end
