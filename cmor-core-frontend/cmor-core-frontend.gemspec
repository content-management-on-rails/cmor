$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require_relative "../lib/cmor/version"
require "cmor/core/frontend/gemspec"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  Cmor::Core::Frontend::Gemspec.defaults(s, load_self: false)
  s.name        = 'cmor-core-frontend'
  s.summary     = 'Cmor::Core::Frontend.'
  s.description = 'Cmor::Core::Frontend Module.'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.add_dependency 'rao-view_helper'
  s.add_dependency 'sprockets-rails'
end
