require 'rspec'
require 'tmpdir'
require 'fileutils'
require 'crequire'

describe "crequire" do
  context "with simple example" do
    crequire 'test/example1', :debug => true

    it "should correctly call factorial" do
      Example1.fact(4).should == 24
    end

    it "should correctly call swap" do
      a = ptrcreate("int", 1)
      b = ptrcreate("int", 2)

      Example1.swap a, b

      a.should == 2
      b.should == 1

      ptrfree(a)
      ptrfree(b)
    end
  end 

  context "with complex example" do
    crequire 'test/example2', :debug => true do
      sum(:int, :int, :return => :int)
      add(:int => :input, :int => :input, :int => :output)
    end  

    it "should correctly call sum" do
      Example2.sum(1, 2).should == 3
      Example2.add(3, 4).should == 7
    end
  end
end
