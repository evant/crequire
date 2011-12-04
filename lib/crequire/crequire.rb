require 'fileutils'

class Require
  def initialize(file_path)
    @full_path = File.expand_path file_path
    @path = File.dirname @full_path
    @name = File.basename file_path
  end

  def require(options = {}, &block)
    if options[:force] or !File.exists? "#{@full_path}.o"

      @src = options[:src]
      @dump_interface = options[:interface]
      if options[:dump]
        dir = options[:dump]
        FileUtils.mkpath dir
        save dir, &block
        install dir
      else
        Dir.mktmpdir do |tmp|
          save tmp, &block
          install tmp
        end
      end
    end

    Kernel.require @name
  end

  def interface(source=nil, &block)
    if source
      source
    else
      swig = SWIG::Context.new(@name)
      swig.input &block if block
      swig.interface
    end
  end

  private

  def save(path, &block)
    save_interface path, &block
    save_extconf path
  end

  def save_interface(path, &block)
    File.open(File.join(path, "#{@name}.i"), 'w') do |file|
      file << interface(@src, &block)
    end
  end

  def save_extconf(path)
    File.open(File.join(path, "extconf.rb"), 'w') do |file|
      file << extconf
    end
  end

  def extconf
    "require 'mkmf'\n" +
    "create_makefile('#{@name}')"
  end

  def install(path)
    try_copy "#{@name}.c", path
    try_copy "#{@name}.h", path

    dir = Dir.pwd
    Dir.chdir path
    `swig -ruby "#{@name}.i"`
    exit if $? != 0

    `ruby extconf.rb`
    `make`
    `make install`
    Dir.chdir dir

    output = File.join path, "#{@name}_wrap.o"
    FileUtils.cp output, "#{@full_path}.o"

    if @dump_interface
      i = File.join path, "#{@name}.i"
      dest = File.join @dump_interface, "#{@name}.i"
      FileUtils.cp i, dest
    end
  end

  def try_copy(name, path)
    from = File.join @path, name
    to = File.join path, name
    if File.exists? from
      FileUtils.cp from, to
    end
  end
end

def crequire(file_path, options = {}, &block)
  Require.new(file_path).require options, &block
end
