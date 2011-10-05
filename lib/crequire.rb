require 'fileutils'
require 'tmpdir'
require 'swig'

def crequire(file_path, options = {}, &block)
  @force = options[:force]
  @interface = options[:interface]

  @file_path = file_path
  @file = split_all(file_path).last

  if @force or !File.exists?("#{file_path}.o")
    Dir.mktmpdir do |tmp|
      @tmp = tmp

      if block
        @swig = SWIG::Context.new
        @swig.context_eval(&block)
        save_interface @swig
      else
        save_interface
      end
      create_extconf
      install
    end
  end

  begin
    require @file_path
  rescue LoadError #try the current directoy if the full path doesn't work
    require @file
  end
end

def create_interface(name, swig=nil)
  out = <<-EOS
%module #{name}
%include "cpointer.i"
%pointer_class(int, Intp);
%pointer_class(double, Doublep);
%pointer_class(char, Charp);
%pointer_functions(char*, charpp);
%{
#{
if swig
  swig.to_sig
else
  "#include \"#{name}.h\""
end
}
%}
#{
if swig
  swig.to_swig
else
  "%include \"#{name}.h\""
end
}
  EOS
end


private

def save_interface(swig=nil)
  File.open("#{temp_path}.i", 'w') do |file|
    file << create_interface(@file, swig)   
  end
end

def create_extconf
  File.open(File.join(@tmp, "extconf.rb"), 'w') do |file|
    file << <<-FILE
require 'mkmf'
create_makefile('#{@file}')
    FILE
  end
end

def install                                  
  copy_in @file_path, @file, ".c"
  copy_in @file_path, @file, ".h"

  dir = Dir.pwd
  Dir.chdir @tmp
  `swig -ruby "#{@file}.i"`
  `ruby extconf.rb`
  `make`
  `make install`
  Dir.chdir dir

  wrap_file = File.join(@tmp, @file + "_wrap.o")
  copy_out wrap_file, @file_path + ".o"
  copy_out File.join(@tmp, @file + ".i"), @file_path + ".i" if @interface
end

def copy_in(file_path, name, ext)
  if File.exists?(file_path + ext)
    FileUtils.cp file_path + ext, File.join(@tmp, name) + ext
  end
end

def copy_out(name, destination)
  path = File.join(@tmp, name)
  if File.exist?(path)
    FileUtils.cp path, destination
  else
    puts "can't find file #{name}"
  end
end

def temp_path
  File.join(@tmp, @file)
end

def split_all(path)
  head, tail = File.split(path)
  return [tail] if head == '.' || tail == '/'
  return [head, tail] if head == '/'
  return split_all(head) + [tail]
end
