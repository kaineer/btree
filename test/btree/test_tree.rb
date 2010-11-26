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
end
