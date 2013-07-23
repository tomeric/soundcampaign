source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '= 4.0.0'

# Daemons:
group :production do
  gem 'thin'
end

# Database:
gem 'pg'
gem 'friendly_id'
gem 'protected_attributes'

# Data:
gem 'mp3info'
gem 'roo',         require: false

# Files:
gem 'aws-sdk'
gem 'paperclip'

# Authentication:
gem 'devise'

# Views:
gem 'formtastic'

# Asset Pipeline:
gem 'sass-rails'
gem 'coffee-rails'
gem 'bootstrap-sass-rails'
gem 'modernizr-rails'
gem 'bourbon'
gem 'uglifier'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'

# I18n:
gem 'rails-i18n', github: 'svenfuchs/rails-i18n'

group :development do
  # Debugging:
  gem 'better_errors'
  gem 'binding_of_caller'
  
  # Heroku:
  gem 'sqlite3',          require: false
  gem 'taps',             require: false
  
  # Guard:
  gem 'rb-fsevent',       require: false
  gem 'guard-bundler',    require: false
  gem 'guard-rspec',      require: false
  
  # Console:
  gem 'pry',              require: false
end

group :test do
  gem 'rspec-rails'
  gem 'spork'
  
  # Test tools:
  gem 'shoulda-matchers'
  gem 'database_cleaner',   require: false
  gem 'ffaker',             require: false
  gem 'factory_girl_rails', require: false
  gem 'fakeweb',            require: false
  gem 'capybara',           require: false
  
  # TDD Helpers:
  gem 'launchy',            require: false
  gem 'fuubar',             require: false
  gem 'turnip',             require: false
  gem 'timecop',            require: false
end
