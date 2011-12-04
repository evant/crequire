require 'rspec'
require 'crequire/swig'

describe SWIG do
    it "should correctly convert a function to a string" do
      SWIG::Context.new("test").input { int sum(:int, :int) }.interface.should
        include("extern int sum(int arg0, int arg1);")
    end

    it "should correctly convert a function into a swig signature" do
      SWIG::Context.new("test").input { void add("int *INPUT", "int *INPUT", "int *OUTPUT") }.interface.should
        include("extern void add(int *INPUT, int *INPUT, int *OUTPUT);")
    end 

    it "should correctly parse pointer returned pointers" do
      SWIG::Context.new("test").input { char* echo("char *INPUT") }.to_s.should
        include("extern char* echo(char *arg0);")
    end

    it "should have the correct pointer_class with default name" do
      SWIG::Context.new("test").input { pointer :int }.interface.should
      include("%pointer_class(int, Intp);")
    end

    it "should have the correct pointer_class with given name" do
      SWIG::Context.new("test").input { pointer :double, :double_pointer }.interface.should
      include("%pointer_class(double, DoublePointer);")
    end
end
