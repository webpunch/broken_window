$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "broken_window/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "broken_window"
  s.version     = BrokenWindow::VERSION
  s.authors     = ["Craig Ambrose"]
  s.email       = ["craig.ambrose@enspiral.com"]
  s.homepage    = "http://app.webpunch12.com"
  s.summary     = "Show me whether the app is broken or not"
  s.description = "Calculate metrics and display a simple broken/not broken dashboard."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 5.0.0"
  s.add_dependency 'acts_as_tree'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'combustion'
  s.add_development_dependency 'rspec-rails'
end
