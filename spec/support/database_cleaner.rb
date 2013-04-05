require 'database_cleaner'

RSpec.configure do |config|
  config.before :suite do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end
end

Spork.each_run do
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean
end
