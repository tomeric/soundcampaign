set :stage, :staging

# This is the Vagrant VM:
server 'localhost', 
  roles: %w{web worker db},
  user:  'deploy',
  ssh_options: { port: 2222 }

fetch(:default_env).merge!(rails_env: :production)
