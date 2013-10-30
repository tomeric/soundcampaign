set :application, 'soundcampaign'

# Git:
set :scm,      :git
set :repo_url, 'git@github.com:tomeric/soundcampaign.git'
set :branch,   -> { `git rev-parse --abbrev-ref HEAD`.chomp }

# Deployment:
set :deploy_to, "/home/deploy/#{fetch(:application)}"

# SSH:
set :pty,         true
set :ssh_options, forward_agent: true,
                  auth_methods:  %w{publickey}

# Capistrano:
set :format,    :pretty
set :log_level, :debug

# Shared files/dirs:
set :linked_files, %w{config/database.yml config/application.yml}
set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:web), in: :sequence do
      # Restart Passenger by touching tmp/restart.txt:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end
  
  after :finishing, 'deploy:cleanup'
end