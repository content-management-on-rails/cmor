$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require_relative "../lib/cmor/version"
require_relative "../cmor_core_backend/lib/cmor/core/backend/gemspec"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  Cmor::Core::Backend::Gemspec.defaults(s)
  s.name        = "cmor_galleries_backend"
  s.summary     = "Cmor Galleries Backend Module."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "cmor_galleries", "= #{Cmor::VERSION}"
end
