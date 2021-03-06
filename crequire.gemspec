# -*- encoding: utf-8 -*-
require File.expand_path('../lib/crequire/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Evan Tatarka"]
  gem.email         = ["evantatarka@gmail.com"]
  gem.description   = %q{A simple way to require c files using swig.}
  gem.summary       = %q{A simple way to require c files using swig.}
  gem.homepage      = "http://github.com/evant/crequire"

  gem.files         = ["lib/crequire/crequire.rb", "lib/crequire/swig.rb", "lib/crequire/version.rb", "lib/crequire.rb", "README.md", "Rakefile", "spec/echo.o", "spec/sum.c", "spec/crequire_spec.rb", "spec/swig_spec.rb", "spec/fact.o", "spec/echo.c", "spec/sum.o", "spec/fact.h", "spec/add.c"]
  gem.test_files    = ["spec/echo.o", "spec/sum.c", "spec/crequire_spec.rb", "spec/swig_spec.rb", "spec/fact.o", "spec/echo.c", "spec/sum.o", "spec/fact.h", "spec/add.c"]
  gem.name          = "crequire"
  gem.require_paths = ["lib"]
  gem.version       = Crequire::VERSION

  gem.add_development_dependency "rspec", "~> 2.7"
end
