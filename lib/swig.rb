module SWIG
  class Functions
    def initialize
      @functions = []
    end

    def method_missing(m, *args)

      if args.size == 1 and args[0].class <= Function
        func = args[0]
        func.return = m
        @functions << func
      else
        func = Function.new(m.to_s)
        func.args = args.map {|arg| arg.to_s }
        return func
      end
    end

    def to_sig
      @functions.map {|f| f.to_sig}.join("\n")
    end

    def to_swig
      @functions.map {|f| f.to_swig}.join("\n")
    end
  end

  class Function
    attr_accessor :name, :args, :return

    def initialize(name)
      @name = name
      @args = []
      @return = :void
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
