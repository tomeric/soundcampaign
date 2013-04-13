require 'factory_girl_rails'
require 'ffaker'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

FactoryGirl.define do
  factory :subscriber do
    email { generate :email }
  end
  
  factory :user do
    email    { generate :email }
    password { 'password'      }
    name     { generate :name  }
  end
  
  factory :label do
    owner { build :user     }
    name  { generate :brand }
  end
  
  factory :release do
    owner { build :user     }
    label { build :label    }
    title { generate :title }
  end
  
  factory :artist do
    name { generate :name }
  end
  
  factory :release_artist do
    release { build :release }
    artist  { build :artist  }
  end
  
  factory :track do
    artist { generate :name  }
    title  { generate :title }
  end
end