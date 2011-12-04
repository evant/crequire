module SWIG
  class Context
    def initialize(name)
      @name = name
      @functions = []
      @pointers = []
    end

    def input(&block)
      instance_eval &block
      self
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

    def <<(input)
      @pointers << input if input.is_a? Pointer
      @functions << input if input.if_a? Function
    end

    def pointer(p, name = nil)
      @pointers << Pointer.new(p, name)    
    end

    def interface
      output = "%module #{@name}\n"
      if @pointers.size > 0
        output << "%include \"cpointer.i\"\n" +
          @pointers.map {|p| p.to_s}.join("\n")
      end
      output << if @functions.size > 0
                  @functions.map {|f| f.to_s}.join("\n")
                else
                  "#include \"#{@name}.h\""
                end
      output << if @functions.size > 0
                  @functions.map {|f| f.to_swig_s}.join("\n")
                else
                  "%include \"#{@name}.h\""    
                end
    end
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

    def to_s
      @context << Function.new(@name).to_sig
    end

    def to_swig_s
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

    def to_s
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

    def to_swig_s
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

  class Pointer
    attr_accessor :name, :class_name

    def initialize(name, class_name)
      @name = name.to_s
      @class_name = class_name ? class_name.to_s : name.to_s + 'p'
    end

    def to_s
      "%pointer_class(#{@name}, #{camelize(@class_name)});"
    end

    private

    def camelize(word)
        word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    end
  end
end
