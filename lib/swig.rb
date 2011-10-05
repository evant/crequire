module SWIG
  class Functions
    def initialize
      @functions = []
    end

    def <<(func)
      @functions << func
    end

    def method_missing(m, *args)
      return Type.new(m, args)
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
      to_swig do |arg,i|
        arg.gsub(/(INPUT)|(OUTPUT)/, "arg#{i}")
      end
    end

    def to_swig
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
      res << ");"
    end
  end
end
