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
gem 'iconv'
gem 'roo'
gem 'mp3info'

# Files:
gem 'aws-sdk'
gem 'paperclip'

# Authentication:
gem 'devise', github: 'plataformatec/devise', branch: 'rails4'

# Frontend:
gem 'sass-rails'
gem 'coffee-rails'
gem 'bootstrap-sass-rails'
gem 'modernizr-rails'
gem 'bourbon'
gem 'uglifier'
gem 'formtastic'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'

# I18n:
gem 'rails-i18n', github: 'svenfuchs/rails-i18n'

group :development do
  gem 'sqlite3'
  gem 'taps'
  gem 'rb-fsevent',       require: false
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry'
end

group :test do
  gem 'rspec-rails',        '~> 2.14.0.rc1'
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
