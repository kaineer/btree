#
#
module BTree
  class Node
    def initialize( tree = nil )
      @tree = tree
      @values = []
      @offsets = []
    end

    def empty?
      @values.empty?
    end
    
    def add_value( value )
      self.elements_per_node

      if leaf?
        add_into_node( value )
        :here
      else
        subnode_for( value )
      end
    end

    def add_into_node( value )
      insert_at( insertion_point_for( value ), value )
    end

    attr_reader :values
    attr_reader :tree

    #
    def subnode_for( value )
      return nil unless @tree
      
      @tree.node_at( @offsets[ insertion_point_for( value ) ])
    end

  protected
    #
    def elements_per_node
      @tree.elements_per_node if @tree
    end

    #
    def leaf?
      true
    end

    #
    def insertion_point_for( value )
      pos = 0
      while value > @values[ pos ]
        pos += 1
        break if pos >= @values.size
      end unless @values.empty?
      pos
    end

    #
    def insert_at( pos, value )
      if pos >= @values.size
        @values << value
      else
        @values.insert( pos, value )
      end
    end
  end
end
