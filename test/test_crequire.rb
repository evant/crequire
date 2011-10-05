require 'rspec'
require 'tmpdir'
require 'fileutils'
require 'crequire'

describe "create_interface" do
  it "should default to including headers" do
    create_interface('test').should == <<-TEXT
%module test
%include "cpointer.i"
%pointer_class(int, Intp);
%pointer_class(double, Doublep);
%pointer_class(char, Charp);
%pointer_functions(char*, charpp);
%{
#include "test.h"
%}
%include "test.h"
    TEXT
  end

  it "should generate a custom interface correctly" do
    swig = SWIG::Context.new
    swig.instance_eval do
      int sum(:int, :int)
    end
    create_interface('test', swig).should == <<-TEXT
%module test
%include "cpointer.i"
%pointer_class(int, Intp);
%pointer_class(double, Doublep);
%pointer_class(char, Charp);
%pointer_functions(char*, charpp);
%{
extern int sum(int arg0, int arg1);
%}
extern int sum(int arg0, int arg1);
    TEXT
  end
end

describe "crequire" do
  context "with simple example" do
    crequire 'test/example1', :force => true

    it "should correctly call factorial" do
      Example1.fact(4).should == 24
    end

    it "should correctly call swap" do
      a = Example1::Intp.new
      a.assign 1
      b = Example2::Intp.new
      b.assign 2

      Example1.swap a, b

      a.value.should == 2
      b.value.should == 1
    end
  end 

  context "with complex example" do
    crequire 'test/example2', :force => true, :interface => true do
      int sum(:int, :int)
      void add("int *INPUT", "int *INPUT", "int *OUTPUT")
      char* echo("char *INPUT")
    end  

    it "should correctly call sum" do
      Example2.sum(1, 2).should == 3
    end

    it "should correctly call add" do
      Example2.add(3, 4).should == 7
    end

    it "should correctly call echo" do
      Example2.echo("hi").value.should == "hi"
    end
  end
end
