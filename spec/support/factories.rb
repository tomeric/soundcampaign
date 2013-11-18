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
  
  factory :campaign do
    release       { build :release      }
    name          { |c| c.release.title }
    email_subject { |c| c.release.title }
    email_from    { generate :email     }
  end
  
  factory :release do
    organization { build :organization }
    label        { build :label        }
    title        { generate :title     }
  end
  
  factory :feedback do
    release    { build :release    }
    subscriber { build :subscriber }
    body       { generate :story   }
  end
  
  factory :rating do
    feedback { build :feedback        }
    track    { build :track           }
    value    { 1.upto(10).to_a.sample }
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
  
  factory :track_event do
    track      { build :track      }
    subscriber { build :subscriber }
    action     'play'
    payload    { Hash.new          }
  end
  
  factory :contact_list do
    organization { build :organization }
    name         { generate :brand     }
  end
  
  factory :contact do
    list  { build :contact_list }
    email { generate :email     }
  end
  
  factory :import do
    spreadsheet { fixture 'empty.csv' }
  end
  
  factory :import_row, class: Import::Row do
    import { build :import }
  end
  
  factory :email_log do
    message_id { SecureRandom.uuid  }
    to         { [generate(:email)] }
    from       {  generate :email   }
    subject    { generate :title    }
    body       { generate :story    }
  end
end