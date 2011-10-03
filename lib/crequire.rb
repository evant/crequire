require 'fileutils'
require 'tmpdir'

def crequire(file_path, options = {})
  @force = options[:force]
  @debug = options[:debug]

  @file_path = file_path
  @file = split_all(file_path).last

  if @force or !File.exists?("#{file_path}.o")
    Dir.mktmpdir do |tmp|
      @tmp = tmp
      create_interface
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

private

def create_interface
  File.open("#{temp_path}.i", 'w') do |file|
    file << <<-FILE
%module #{@file}
%{
#include "#{@file}.h"
%}
%include "#{@file}.h"
%include "cpointer.i"
    FILE
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

  FileUtils.cp File.join(@tmp, @file + "_wrap.o"), @file_path + ".o"
end

def copy_in(file_path, name, ext)
  if File.exists?(file_path + ext)
    FileUtils.cp file_path + ext, File.join(@tmp, name) + ext
  elsif @debug
    puts "could not find file: #{file_path + ext} in #{Dir.pwd}"
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
