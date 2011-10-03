require 'fileutils'
require 'tmpdir'

def crequire(file_path, options = {})
  if options[:force] or !File.exists?("#{file_path}.o")
    @file_path = file_path
    @file = split_all(file_path).last
    Dir.mktmpdir do |tmp|
      @tmp = tmp
      create_interface
      create_extconf
      install
    end
  end

  require file_path
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
%include "pointer.i"
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
  if File.exists?(@file_path + ".c")
    FileUtils.cp @file_path + ".c", File.join(@tmp, @file) + ".c"
  end
  if File.exists?(@file_path + ".h")
    FileUtils.cp @file_path + ".h", File.join(@tmp, @file) + ".h"
  end

  dir = Dir.pwd
  Dir.chdir @tmp
  `swig -ruby "#{@file}.i"`
  `ruby extconf.rb`
  `make`
  `make install`
  Dir.chdir dir

  FileUtils.cp File.join(@tmp, @file + "_wrap.o"), @file_path + ".o"
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
