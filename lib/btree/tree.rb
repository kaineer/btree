require File.join( File.dirname( __FILE__ ), "node" )

module BTree
  class Tree
    def initialize
      @root = nil
    end

    def root
      @root ||= new_node
    end

    def add_value( value )
      find_node_and_add_value( self.root, value )
    end

    def find_node_and_add_value( node, value )
      add_result = node.add_value( value )
      case add_result
      when :here
        return # there's nothing to do anymore
      when :splitme
        split_node( node )
      when BTree::Node
        find_node_and_add_value( add_result, value )
      end
    end
  end
end
