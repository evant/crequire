#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new(:test) do |t|
  t.rspec_opts = ["--color"]
end

file :gemspec => "crequire.gemspec.erb" do |t|
  `erb "crequire.gemspec.erb" > "crequire.gemspec"`
end

task :default => [:test]
