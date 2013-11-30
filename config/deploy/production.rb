set :stage, :staging

# This is the *main* server:
server '146.185.183.134',        # jackson.soundcampaign.com
  roles: %w{app web worker db},
  user:  'deploy'

fetch(:default_env).merge!(rails_env: :production)
