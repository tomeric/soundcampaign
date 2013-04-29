require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  
  config.before :suite do
    DatabaseCleaner.clean
  end
end

Spork.each_run do
  DatabaseCleaner.clean
end
