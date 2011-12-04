require 'tmpdir'
require 'fileutils'
require 'crequire'

describe "interface" do
  before :each do
    @crequire = Require.new 'test'
  end

  it "should use the interface source if given" do
    @crequire.interface("test").should == "test"
  end

  it "should include the module name" do
    @crequire.interface.should include("%module test")  
  end

  it "should default to including headers" do
    @crequire.interface.should include('#include "test.h"')
    @crequire.interface.should include('%include "test.h"')
  end

  it "should generate a custom interface correctly" do
    @crequire.interface { int sum(:int, :int) }.should
    include("extern int sum(int arg0, int arg1);")
  end

  context "with pointers" do
    it "should include cpointer.i" do
      @crequire.interface { pointer :int }.should
      include('%include "cpointer.i"')
    end

    it "should include a pointer with the given name and class name" do
      @crequire.interface { pointer :int, :int_pointer }.should
      include('%pointer_class(int, IntPointer);')
    end

    it "should include a pointer with a default class name" do
      @crequire.interface { pointer :int }.should
      include('%pointer_class(int, Intp);')
    end
  end
end

describe "crequire" do
  context "with a simple function" do
    before :all do
      crequire 'spec/fact', :force => true
    end

    it "should correctly call the function" do
      Fact.fact(4).should == 24
    end
  end

  context "with a function with INPUT and OUTPUT pointers" do
    before :all do
      crequire 'spec/add', :force => true do
        void add("int *INPUT", "int *INPUT", "int *OUTPUT")
      end

      it "should correctly call the function" do
        Add.add(1, 2).should == 3
      end
    end
  end

  context "with a function with char*" do
    before :all do
      crequire 'spec/echo', :force => true do
        char* echo("char*")
      end
    end

    it "should correctly call the function" do
      Echo.echo("test").should == "test"
    end
  end

  context "with custom interface input" do
    before :all do
      crequire 'spec/sum', :force => true,
        "%module sum\n" +
        "%{\nextern int sum(int arg0, int arg1);\n%}" +
        "extern int sum(int arg0, int arg1);"
    end

    it "should correctly call the function" do
      Sum.sum(1, 2).should == 3
    end
  end
end
