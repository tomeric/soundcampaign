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
  
  factory :role do
    user { build :user }
    name 'admin'
  end
  
  factory :label do
    organization { build :organization }
    name         { generate :brand     }
  end
  
  factory :campaign do
    release       { build :release  }
    name          { release.title   }
    email_subject { release.title   }
    email_from    { generate :email }
  end
  
  factory :recipient do
    campaign { build :campaign  }
    email    { generate :email  }
    secret   { generate :secret }
  end
  
  factory :release do
    organization { build :organization          }
    label        { build :label,
                     organization: organization }
    title        { generate :title              }
  end
  
  factory :feedback do
    release   { build :release   }
    recipient { build :recipient }
    body      { generate :story  }
  end
  
  factory :rating do
    feedback { build :feedback        }
    track    { build :track           }
    value    { 1.upto(10).to_a.sample }
  end
  
  factory :cover do
    attachment   { fixture 'cover.jpg'          }
    organization { build :organization          }
    coverable    { build :release,
                     organization: organization }
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
    
    factory :released_track do
      release { build :release }
    end
  end
  
  factory :track_event do
    track        { build :released_track }
    recipient    { build :recipient      }
    action       'play-track'
    payload_json { Hash.new.to_json      }
    
    factory :played_track_event do
    end
    
    factory :paused_track_event do
      action 'pause-track'
    end
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
  
  factory :import_row,
    class: Import::Row do
    import { build :import }
  end
  
  factory :email_log do
    message_id { SecureRandom.uuid  }
    to         { [generate(:email)] }
    from       {  generate :email   }
    subject    { generate :title    }
    body       { generate :story    }
    
    factory :opened_email_log do
      opened_at { Time.now.utc }
    end
    
    factory :opened_email_log_with_campaign do
      opened_at { Time.now.utc                         }
      campaign  { build :campaign                      }
      recipient { build :recipient, campaign: campaign }
      to        { [recipient.email]                    }
    end
    
    factory :unopened_email_log do
      opened_at { nil }
    end
  end
  
  factory :release_event do
  end
  
  factory :campaign_open_event,
    parent: :release_event,
    class: CampaignOpenEvent do
    parent { build :opened_email_log_with_campaign }
  end
  
  factory :feedback_event,
    parent: :release_event,
    class:  FeedbackEvent do
    parent { build :feedback }
  end
  
  factory :track_play_event,
    parent: :release_event,
    class:  TrackPlayEvent do
    parent { build :played_track_event }
  end
end