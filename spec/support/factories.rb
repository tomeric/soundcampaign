require 'factory_girl_rails'
require 'ffaker'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

FactoryGirl.define do
  factory :user do
    email    { generate :email }
    password { 'password'      }
    name     { generate :name  }
  end
  
  factory :label do
    name { generate :brand }
  end
end