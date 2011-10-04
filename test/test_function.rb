require 'rspec'
require '../lib/swig'

describe Function do
  context "with sum" do
    before :each do
      @sum= Function.new("sum")
      @sum.args = [:int, :int]
      @sum.return = :int
    end

    it "should have the correct signiture" do
      @sum.to_sig.should == "extern int sum(int arg0, int arg1);"
    end

    it "should have the correct swig signature" do
      @sum.to_swig.should == "extern int sum(int arg0, int arg1);"
    end 
  end

  context "with add" do
    before :each do
      @add = Function.new("add")
      @add.args = ["int *INPUT", "int *INPUT", "int *OUTPUT"]
    end

    it "should have the correct signiture" do
      @add.to_sig.should == "extern void add(int *arg0, int *arg1, int *arg2);"
    end

    it "should have the correct swig signature" do
      @add.to_swig.should == "extern void add(int *INPUT, int *INPUT, int *OUTPUT);"
    end 
  end
end