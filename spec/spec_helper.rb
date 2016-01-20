require 'rubygems'
require 'bundler/setup'

require 'combustion'

Combustion.initialize! :all

require 'rspec/rails'

RSpec.configure do |config|
  config.color = true
  config.use_transactional_fixtures = true
  config.render_views = false
end