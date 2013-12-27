require 'rubygems'
require 'spork'

ENV["RAILS_ENV"] ||= 'test'

Spork.prefork do
  require 'simplecov'
  SimpleCov.start 'rails'

  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'
  
  RSpec.configure do |config|
    config.mock_with :rspec
    config.expect_with :rspec do |c|
      c.syntax = :expect
    end
  end
end

Spork.each_run do
  # Requires supporting files with custom matchers and macros, etc,
  # in ./support/ and its subdirectories.
  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| load f}
end
