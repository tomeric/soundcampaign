set :stage, :production

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a has can be used to set
# extended properties on the server.
server 'example.com',
  roles: %w{web worker db}

fetch(:default_env).merge!(rails_env: :production)
