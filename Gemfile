source 'https://rubygems.org'

gem 'rails', github: 'rails/rails'

# Daemons:
group :production do
  gem 'unicorn'
end

# Database:
gem 'pg'
gem 'friendly_id'
gem 'paperclip'

# Frontend:
group :assets do
  gem 'sass-rails',   '~> 4.0.0.beta1'
  gem 'coffee-rails', '~> 4.0.0.beta1'
  gem 'uglifier'
end
gem 'formtastic'
gem 'jquery-rails'
gem 'turbolinks'

# I18n:
gem 'rails-i18n', github: 'svenfuchs/rails-i18n'
gem 'i18n-js',    github: 'fnando/i18n-js'

group :development do
  gem 'rb-fsevent',       require: false
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry'
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
end
