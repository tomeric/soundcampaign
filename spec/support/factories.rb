require 'factory_girl_rails'
require 'ffaker'
require 'paperclip/io_adapters/pathname_adapter'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  
  def fixture(name)
    Rails.root.join('spec', 'fixtures', name)
  end
end

FactoryGirl.define do
  factory :subscriber do
    email { generate :email }
  end
  
  factory :organization do
    name { generate :brand }
  end
  
  factory :user do
    organization { build :organization }
    email        { generate :email     }
    password     { 'password'          }
    name         { generate :name      }
  end
  
  factory :label do
    organization { build :organization }
    name         { generate :brand     }
  end
  
  factory :release do
    organization { build :organization }
    label        { build :label        }
    title        { generate :title     }
  end
  
  factory :artist do
    organization { build :organization }
    name         { generate :name      }
  end
  
  factory :release_artist do
    release { build :release }
    artist  { build :artist  }
  end
  
  factory :track do
    attachment   { fixture 'track.mp3' }
    organization { build :organization }
    artist       { generate :name      }
    title        { generate :title     }
  end
  
  factory :contact_list do
    organization { build :organization }
    name         { generate :brand     }
  end
  
  factory :contact do
    list  { build :contact_list }
    email { generate :email     }
  end
end