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
end
