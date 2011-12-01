require 'fileutils'

class Require
  def initialize(file_path)
    @full_path = File.expand_path file_path
    @path = File.dirname @full_path
    @name = File.basename file_path
  end

  def crequire(options = {}, &block)

    if options[:force] or !File.exists? "#{@full_path}.o"
      Dir.mktmpdir do |tmp|
        save tmp, &block
        install tmp
      end
    end

    require @name
  end

  def interface(&block)

  input = if block
            swig = SWIG::Context.new
            swig.instance_eval &block
            swig
          end

return <<-EOS
%module #{@name}
%include "pointer.i"
%include "cpointer.i"
%pointer_class(int, Intp)
%pointer_class(double, Doublep)
%{
#{
  if block
    input.to_sig
  else
    "#include \"#{@name}.h\""
  end
}
%}
#{
  if block
    input.to_swig
  else
    "%include \"#{@name}.h\""    
  end
}
EOS
  end

  def save(path, &block)
    save_interface path, &block
    save_extconf path
  end

  private

  def save_interface(path, &block)
    File.open(File.join(path, "#{@name}.i"), 'w') do |file|
      file << interface(&block)
    end
  end

  def save_extconf(path)
    File.open(File.join(path, "extconf.rb"), 'w') do |file|
      file << extconf
    end
  end

  def extconf
return <<-EOS
require 'mkmf'
create_makefile('#{@name}')
EOS
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
  Require.new(file_path).crequire options, &block
end
