class SWIG
  def initialize
    @functions = []
  end

  def method_missing(m, *args)
    func = Function.new(m.to_s)

    args.each do |arg|
      if arg.respond_to?(:has_key?) and arg[:return]
        func.return = arg[:return].to_s
      else
        func.args << arg.to_s
      end
    end

    @functions << func
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
