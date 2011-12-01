module SWIG
  class Context
    def initialize
      @functions = []
    end

<<<<<<< HEAD
    def method_missing(m, *args)
      if args.size == 0
        Unknown.new m, @functions
      elsif args.size == 1 and [Function, Unknown].include? args[0].class
        func = args[0]
        func.return = m
        @functions << func
      else
        func = Function.new(m.to_s)
        func.args = args.map {|arg| arg.to_s }
        return func
      end
=======
    def <<(func)
      @functions << func
    end

    def method_missing(m, *args)
      return Type.new(m, args)
>>>>>>> 1bb8006dc4855483ca9ec5770e93f9cad9b93cf6
    end

    def to_sig
      @functions.map {|f| f.to_sig}.join("\n")
    end

    def to_swig
      @functions.map {|f| f.to_swig}.join("\n")
    end
  end

  class Type
    attr_accessor :name, :args

    def initialize(name, args)
      @name = name
      @args = args
    end

    def *(other)
      @name += "*"
      @args << other
    end
  end

  INPUT = Type.new("INPUT", [])
  OUTPUT = Type.new("OUTPUT", [])

  class Function
    def initialize(sig)
      @sig = sig
    end

    def to_sig
<<<<<<< HEAD
      to_s do |arg,i|
        if arg =~ /(INPUT)|(OUTPUT)/
          arg.to_s.gsub(/(INPUT)|(OUTPUT)/, "arg#{i}")
        else
          arg.to_s + " arg#{i}"
        end
=======
      to_swig do |arg,i|
        arg.gsub(/(INPUT)|(OUTPUT)/, "arg#{i}")
>>>>>>> 1bb8006dc4855483ca9ec5770e93f9cad9b93cf6
      end
    end

    def to_swig
<<<<<<< HEAD
      to_s do |arg,i|
        if arg =~ /(INPUT)|(OUTPUT)/
          arg.to_s
        else
          arg.to_s + " arg#{i}"
        end
      end
    end

    def to_s
      res = "extern #{@return} #{@name}("
      res << @args.each_with_index.map do |arg,i|
        if block_given?
          yield(arg, i)
        else
          arg.to_s
        end
      end.join(", ")
=======
      ret = @sig.name
      name = @sig.args[0].name
      args = @sig.args[0].args.each_with_index.map do |arg,i|
        if arg.args.size > 0
          a = arg.name + " " + arg.args[0]
          yield(a,i) if block_given?
        else
          arg.name + " arg#{i}"
        end  
      end

      res = "extern #{ret} #{name}"
      res << args.join(", ")
>>>>>>> 1bb8006dc4855483ca9ec5770e93f9cad9b93cf6
      res << ");"
    end
  end

  private

  class Unknown
    def initialize(name, functions)
      @name = name
      @functions = functions
    end

    def return=(value)
      func = Function.new(@name)
      func.return = value
      return func
    end

    def *(func)
      func.return = @name.to_s + "*"  
      @functions << func
    end
  end
end
