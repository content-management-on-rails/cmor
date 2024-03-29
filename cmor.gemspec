$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cmor/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cmor"
  s.version     = ::Cmor::VERSION
  s.authors     = ["BeeGood IT"]
  s.email       = ["info@beegoodit.de"]
  s.summary     = "Content management on rails"
  s.description = "(C)ontent (m)anagement (o)n (r)ails a.k.a Seymore - Let's you see more and makes your content²!"
  s.license     = "MIT"

  s.files = Dir["{lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.required_ruby_version = ">= 3.1"

  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'guard-bundler'
  s.add_development_dependency 'guard-standardrb'
  s.add_development_dependency 'git_log_generator'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'standard'
end
