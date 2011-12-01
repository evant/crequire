# -*- encoding: utf-8 -*-
require File.expand_path('../lib/crequire/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Evan Tatarka"]
  gem.email         = ["evantatarka@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "crequire"
  gem.require_paths = ["lib"]
  gem.version       = Crequire::VERSION

  gem.add_dependency "sourcify", "~> 0.5"

  gem.add_development_dependency "rspec", "~> 2.7"
end