require 'rubygems'
require 'rubygems/package_task'
require 'rake/clean'
require 'rake/testtask'

CLEAN.include("pkg", "coverage")

spec = Gem::Specification.load('vas.gemspec')

Gem::PackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

Rake::TestTask.new do |t|
  t.pattern = "test/**/test_*.rb"
end


task :default => [:clean, :test, :package]
