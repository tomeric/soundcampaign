set :stage, :staging

# This is the *main* server:
server 'jackson.soundcampaign.com',
  roles:   %w{app web db},
  user:    'deploy',
  primary: true

# These are the workers:
%w[miley bieber].each do |bitch|
  server "#{bitch}.soundcampaign.com",
    roles: %w{app worker},
    user:  'deploy'
end

fetch(:default_env).merge!(rails_env: :production)
