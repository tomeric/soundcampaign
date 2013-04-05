require 'turnip/capybara'

Dir.glob('spec/acceptance/**/*_steps.rb') { |f| load f, true }
