module SWIG
  class Context
    def initialize
      @functions = []
    end

    def method_missing(m, *args)
      if args.size == 1 and args[0].class <= Function
        func = args[0]
        func.return = m
        @functions << func
      elsif args.size == 0
        Unknown.new(m.to_s, self)
      else
        Function.new(m.to_s, args.map {|arg| arg.to_s})
      end
    end

    def <<(f)
      @functions << f
    end

    def to_sig
      @functions.map {|f| f.to_sig}.join("\n")
    end

    def to_swig
      @functions.map {|f| f.to_swig}.join("\n")
    end
  end

  class Unknown
    attr_accessor :name, :args

    def initialize(name, context)
      @context = context
      @name = name
      @args = []
    end

    def *(other)
      @context << Function.new(other.name, other.args, @name + "*")
    end

    def to_sig
      @context << Function.new(@name).to_sig
    end

    def to_swig
      @context << Function.new(@name).to_swig
    end
  end

  class Function
    attr_accessor :name, :args, :return

    def initialize(name, args = [], ret = :void)
      @name = name
      @args = args
      @return = ret
    end

    def to_sig
      res = "extern #{@return} #{@name}("
      res << @args.each_with_index.map do |arg,i|
        if arg =~ /(INPUT)|(OUTPUT)/
          arg.to_s.gsub(/(INPUT)|(OUTPUT)/, "arg#{i}")
        else
          arg.to_s + " arg#{i}"
        end
      end.join(", ")
      res << ");"
    end

    def to_swig
      res = "extern #{@return} #{@name}("
      res << @args.each_with_index.map do |arg,i|
        if arg =~ /(INPUT)|(OUTPUT)/
          arg.to_s
        else
          arg.to_s + " arg#{i}"
        end
      end.join(", ")
      res << ");"
    end
  end
end
