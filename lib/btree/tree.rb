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

    def split_node( node, parent = nil )
      unless parent
        #
        # In case we're splitting root node,
        #   left/right halves come to just created nodes
        #   median value comes into root node
        #
        left_node = new_node( node.left_half )
        right_node = new_node( node.right_half )
        node.reset( [ node.median ], [ left_node, right_node ] )
      else
        #
        # Otherwise
        #   node keeps left half of values 
        #   new node gets right half
        #   median value comes to parent (and maybe, splits it)
        #
        # TODO: code for splitting when parent is provided
      end
    end
  end
end
