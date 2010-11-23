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
      @node.expects( :add_into_node )
      @node.add_value( 10 )
    end

    it "should return :here when value added into node" do
      @node.stubs( :leaf? ).returns( true )
      @node.stubs( :add_into_node )
      @node.add_value( 10 ).should.be == :here
    end

    it "should access subnode if node is not leaf" do
      @node.stubs( :leaf? ).returns( false )
      @node.expects( :subnode_for ).with( "value-tag" )

      @node.add_value( "value-tag" )
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
end
