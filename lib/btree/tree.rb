require File.join( File.dirname( __FILE__ ), "node" )

module BTree
  class Tree
    def initialize
      @root = nil
    end

    def add_value( value )
      @root ||= new_node
      node = @root
      case node.add_value( value )
      when :splitme
        split_node( node )
      when :here
        # do nothing
      when BTree::Node
        # proceed deeper
      end
    end
  end
end
