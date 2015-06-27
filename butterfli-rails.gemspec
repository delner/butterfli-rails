# coding: utf-8
$LOAD_PATH << File.expand_path("../lib", __FILE__)
require 'butterfli/rails/version'

Gem::Specification.new do |s|
  s.name          = "butterfli-rails"
  s.version       = Butterfli::Rails::VERSION
  s.authors       = ["David Elner"]
  s.email         = ["david@davidelner.com"]
  s.summary       = %q{Provides endpoints and data processing for public APIs.}
  s.description   = %q{Provides endpoints and data processing for public APIs, typically social media.}
  s.homepage      = "http://github.com/delner/butterfli-rails"
  s.license       = "MIT"

  s.files       = `git ls-files`.split("\n")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files  = `git ls-files -- {spec,features,gemfiles}/*`.split("\n")

  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")

  s.add_dependency "butterfli", "~> 0.0.1"
  s.add_dependency "rails", ">= 3.2.22"

  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec", "~> 3.3"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-stack_explorer", "~> 0.4.9"
  s.add_development_dependency "yard", "~> 0.8.7.6"
end
