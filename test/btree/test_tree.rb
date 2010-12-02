require File.join( File.dirname( __FILE__ ), "../test_helper.rb" )
require 'btree/tree'

describe "BTree::Tree" do
  it "should be created with constructor w/o exception" do
    assert_nothing_raised {|| BTree::Tree.new }
  end

  describe "#add_value, Adding to empty tree" do
    before do
      @tree = BTree::Tree.new
      @node = mock( "node" )
      @node.stubs( :add_value )
    end

    it "should create first node on first value adding" do
      @tree.expects( :new_node ).returns( @node )
      @tree.add_value( 10 )
    end

    it "should try to add value into just created root node" do
      @node.expects( :add_value ).with( 10 )
      @tree.stubs( :new_node ).returns( @node )
      @tree.add_value( 10 )
    end
  end

  describe "#add_value, Adding to full root node" do
    before do
      @tree = BTree::Tree.new
      @node = mock( "node" )
      @node.stubs( :add_value )

      @subnode = BTree::Node.new( @tree )
      
      @tree.stubs( :root ).returns( @node )
    end

    it "should try to split node, that got to be full" do
      @node.stubs( :add_value ).with( 10 ).returns( :splitme )
      @tree.expects( :split_node ).with( @node )

      @tree.add_value( 10 )
    end

    it "should try to add value to subnode returned" do
      @node.stubs( :add_value ).with( 10 ).returns( @subnode )
      @subnode.expects( :add_value ).with( 10 )

      @tree.add_value( 10 )
    end
  end

  describe "#split_node w/o parent node" do
    before do
      @tree = BTree::Tree.new
      @node = mock( "node" )

      @tree.stubs( :new_node ).returns( nil )

      @left_values = %w( left half values )
      @right_values = %w( right half values )

      @node.stubs( :left_half ).returns( @left_values )
      @node.stubs( :right_half ).returns( @right_values )
      @node.stubs( :median ).returns( "median-tag" )

      @node.stubs( :reset )
    end

    it "should access node's left half, right half and median value" do
      @node.expects( :left_half ).returns( [] )
      @node.expects( :right_half ).returns( [] )
      @node.expects( :median ).returns( "median-tag" )

      @tree.split_node( @node )
    end

    it "should create left node w/ left values and right node w/ right ones" do
      @tree.expects( :new_node ).with( @left_values )
      @tree.expects( :new_node ).with( @right_values )

      @tree.split_node( @node )
    end

    it "should reset current node with left(r)-median-right(r) values" do
      @left_node = mock( "left-node" )
      @right_node = mock( "right-node" )

      @tree.stubs( :new_node ).with( @left_values ).returns( @left_node )
      @tree.stubs( :new_node ).with( @right_values ).returns( @right_node )
      
      @node.expects( :reset ).with( [ "median-tag" ], [ @left_node, @right_node ] )

      @tree.split_node( @node )
    end
  end

  # ALSO: need to store tree on disk somehow
end
