require File.join( File.dirname( __FILE__ ), "../test_helper" )
require 'btree/node'

describe "BTree node" do
  describe "Node creation" do
    it "should be created with constructor" do
      assert_nothing_raised {|| BTree::Node.new }
    end

    it "should be created with first parameter @tree" do
      @node = BTree::Node.new( "tree-tag" )
      
      @node.tree.should.be == "tree-tag"
    end
  end

  describe "Simple value adding without tree" do
    before do
      @node = BTree::Node.new
    end

    it "should be empty when created" do
      @node.should.be.empty?
    end

    it "should be capable of adding values" do
      assert_nothing_raised {|| @node.add_value( 10 )}
    end

    it "should not be empty after value is added" do
      @node.add_value( 10 )
      @node.should.not.be.empty?
    end

    it "should give out values added" do
      @node.add_value( 10 )
      @node.add_value( 20 )
      @node.values.should.be == [ 10, 20 ]
    end

    it "should give out values sorted" do
      @node.add_value( 20 )
      @node.add_value( 30 )
      @node.add_value( 10 )
      @node.values.should.be == [ 10, 20, 30 ]
    end
  end


  describe "Addition inside of tree" do
    before do
      @tree = mock( "tree" )
      @tree.stubs( :elements_per_node ).returns( 11 )
      @node = BTree::Node.new( @tree )
      @node.stubs( :full? ).returns( false )
    end

    it "should access tree's elements per node value when adding value" do
      @tree.expects( :elements_per_node ).returns( 11 )
      @node.stubs( :leaf? ).returns( true )
      @node.add_value( 10 )
    end

    it "should access leaf? method when adding value" do
      @node.expects( :leaf? ).returns( true )
      @node.add_value( 10 )
    end

    it "should add into node when leaf? returns true" do
      @node.stubs( :leaf? ).returns( true )
      @node.expects( :add_into_node ).with( 10 )
      @node.add_value( 10 )
    end

    it "should return :here when value added into node" do
      @node.stubs( :leaf? ).returns( true )
      @node.add_value( 10 ).should.be == :here
    end

    it "should access subnode if node is not leaf" do
      @node.stubs( :leaf? ).returns( false )
      @node.expects( :subnode_for ).with( "value-tag" )

      @node.add_value( "value-tag" )
    end

    it "should return :splitme when is full after value insering" do
      @node.stubs( :leaf ).returns( true )
      @node.stubs( :full? ).returns( true )
      @node.add_value( 10 ).should.be == :splitme
    end
  end

  describe "Getting subnode for value" do
    class TestNode < BTree::Node
      def initialize( tree, values, offsets )
        @tree = tree
        @values = values
        @offsets = offsets
      end
    end
    
    before do
      @tree = mock( "tree" )
      @node = TestNode.new( @tree, [ 10, 20 ], [ "before-10", "between-10-and-20", "after-20" ] )
    end

    it "should try to get a node from tree, before first value" do
      @tree.expects( :node_at ).with( "before-10" )
      @node.subnode_for( 5 )
    end

    it "should try to get a node from tree, after last value" do
      @tree.expects( :node_at ).with( "after-20" )
      @node.subnode_for( 25 )
    end

    it "should try to get a node from tree, between first and next values" do
      @tree.expects( :node_at ).with( "between-10-and-20" )
      @node.subnode_for( 15 )
    end
  end

  describe "#reset" do
    before do
      @tree = mock( "tree" )
      @node = BTree::Node.new( @tree )

      @values = %w( foo bar zee )

      @offsets = %w( hax neeh weoi ahhz )
      @subnodes = @offsets.map do |offset|
        node = mock( "node-#{offset}" )
        node.stubs( :offset ).returns( offset )
        node
      end

      @subnode_offsets = [ 1234, 5678, 9012, 3456 ]
    end

    it "should accept one parameter with values" do
      @node.reset( @values )

      @node.values.should.be == @values
    end

    it "should store subnodes' offsets from second parameter" do
      @node.reset( @values, @subnodes )
      
      @node.offsets.should.be == @offsets
    end

    it "should store offsets if second parameter consists of integers" do
      @node.reset( @values, @subnode_offsets )
      
      @node.offsets.should.be == @subnode_offsets
    end
  end

  describe "splitting" do
    before do
      @tree_odd = mock( "tree-odd" )
      @tree_odd.stubs( :elements_per_node ).returns( 5 )
      @node_odd = BTree::Node.new( @tree_odd )

      @tree_even = mock( "tree-even" )
      @tree_even.stubs( :elements_per_node ).returns( 6 )
      @node_even = BTree::Node.new( @tree_even )

      @values_odd = [ 1, 5, 7, 10, 11 ]
      @values_even = @values_odd + [ 17 ]
    end

    it "should be left: 2, right: 2 and middle - 3rd for 5 values" do
      @node_odd.reset( @values_odd )

      values, offsets = @node_odd.left_part
      values.size.should.be == 2

      values, offsets = @node_odd.right_part
      values.size.should.be == 2

      @node_odd.median.should.be == 7
    end

    it "should be left: 2, right: 3 and middle - 3rd for 6 values" do
      @node_even.reset( @values_even )
      
      values, offsets = @node_even.left_part
      values.size.should.be == 2

      values, offsets = @node_even.right_part
      values.size.should.be == 3

      @node_even.median.should.be == 7
    end
  end
end
