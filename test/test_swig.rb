require 'rspec'
require '../lib/swig'

describe SWIG do
  context "with sum" do
    before :each do
      @swig = SWIG.new
      @swig.sum(:int, :int, :return => :int)
    end
    
    it "should have the correct signiture" do
      @swig.to_sig.should == "extern int sum(int arg0, int arg1);"
    end

    it "should have the correct swig signature" do
      @swig.to_swig.should == "extern int sum(int arg0, int arg1);"
    end 
  end

  context "with add" do
    before :each do
      @swig = SWIG.new
      @swig.add("int *INPUT", "int *INPUT", "int *OUTPUT")
    end
    
    it "should have the correct signiture" do
      @swig.to_sig.should == "extern void add(int *arg0, int *arg1, int *arg2);"
    end

    it "should have the correct swig signature" do
      @swig.to_swig.should == "extern void add(int *INPUT, int *INPUT, int *OUTPUT);"
    end 
  end
end
