source 'https://rubygems.org'
ruby '2.1.0'

gem 'rails', '= 4.0.0'

# Background processing:
gem 'daemons'
gem 'whenever',                  require: false
gem 'delayed_job_active_record'
gem 'delayed_paperclip'
gem 'delayed_job_web'

# Configuration:
gem 'settingslogic'
gem 'dotenv-rails'

# Database:
gem 'pg'
gem 'friendly_id'
gem 'protected_attributes'

# Data:
gem 'roo',             require: false
gem 'taglib-ruby',     require: false
gem 'waveformjson',    require: false
gem 'charlock_holmes', require: false

# Mail:
gem 'mandrill-rails'
gem 'premailer-rails'

# Files:
gem 'aws-sdk'
gem 'paperclip'

# Authentication:
gem 'devise'

# Views:
gem 'formtastic',   '>= 2.3.0.rc2'
gem 'dynamic_form'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

# Asset Pipeline:
gem 'sass-rails'
gem 'coffee-rails'
gem 'd3-rails'
gem 'bootstrap-sass-rails', '~> 2.3.2.1'
gem 'modernizr-rails'
gem 'bourbon'
gem 'uglifier'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'

# I18n:
gem 'rails-i18n', github: 'svenfuchs/rails-i18n'

# Logging:
gem 'honeybadger'
gem 'delayed_job_honeybadger'

group :production do
  # Web server:
  gem 'unicorn'
end

group :development do
  # Debugging:
  gem 'better_errors'
  gem 'binding_of_caller'

  # Mail:
  gem 'letter_opener'
  gem 'mail_view'

  # Deployment:
  gem 'capistrano-rails',   '= 1.0.0'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler', '= 1.0.0'

  # Heroku:
  gem 'sqlite3',          require: false
  gem 'taps',             require: false

  # Guard:
  gem 'guard'
  gem 'rb-fsevent',       require: false
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
  gem 'email_spec',         require: false

  # Reports:
  gem 'simplecov',          require: false
end
