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
      @node = BTree::Node.new( @tree )
    end

    it "should access tree's elements per node value when adding value" do
      @tree.expects( :elements_per_node ).returns( 11 )
      @node.stubs( :leaf? )
      @node.add_value( 10 )
    end

    it "should access leaf? method when adding value" do
      @tree.stubs( :elements_per_node ).returns( 11 )
      @node.expects( :leaf? ).returns( true )
      @node.add_value( 10 )
    end

    it "should access subnode when leaf? returns false" do
      @tree.stubs( :elements_per_node ).returns( 11 )
      @node.stubs( :leaf? ).returns( false )
      # TODO
    end
  end


end
