module BTree
  class Tree
    def initialize
      @root = nil
    end

    def add_value( value )
      @root = new_node
      @root.add_value( value )
    end
  end
end
