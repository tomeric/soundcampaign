set :stage, :staging

# This is the *main* server:
server 'jackson.soundcampaign.com', 
  roles: %w{app web worker db},
  user:  'deploy'

fetch(:default_env).merge!(rails_env: :production)
