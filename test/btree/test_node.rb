require File.join( File.dirname( __FILE__ ), "../test_helper" )
require 'btree/node'

describe "BTree node" do
  it "should be created with constructor" do
    assert_nothing_raised {|| BTree::Node.new }
  end

  describe "Simple value adding" do
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
  end
end
