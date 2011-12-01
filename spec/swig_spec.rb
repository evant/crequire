require 'rspec'
require 'crequire/swig'

describe SWIG do
  context "with sum" do
    before :each do
      @swig = SWIG::Context.new
      @swig.instance_eval do
        int sum(:int, :int)
      end
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
      @swig = SWIG::Context.new
      @swig.instance_eval do
        void add("int *INPUT", "int *INPUT", "int *OUTPUT")
      end
    end
    
    it "should have the correct signiture" do
      @swig.to_sig.should == "extern void add(int *arg0, int *arg1, int *arg2);"
    end

    it "should have the correct swig signature" do
      @swig.to_swig.should == "extern void add(int *INPUT, int *INPUT, int *OUTPUT);"
    end 
  end

  context "with echo" do
    before :each do
      @swig = SWIG::Context.new
      @swig.instance_eval do
        char* echo("char *INPUT")
      end
    end

    it "should have the correct signiture" do
      @swig.to_sig.should == "extern char* echo(char *arg0);"
    end

    it "should have the correct swig signature" do
      @swig.to_swig.should == "extern char* echo(char *INPUT);"
    end 
  end
end
