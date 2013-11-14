set :application, 'soundcampaign'
set :rails_env,   'production'

# SSH:
set :pty,         true
set :ssh_options, forward_agent: true,
                  auth_methods:  %w{publickey}

# Git:
set :scm,      :git
set :repo_url, 'git@github.com:tomeric/soundcampaign.git'
set :branch,   -> { `git rev-parse --abbrev-ref HEAD`.chomp }

# Deployment:
set :home_dir,  "/home/deploy"
set :deploy_to, "#{fetch(:home_dir)}/#{fetch(:application)}"

# RVM config:
set :rvm_type,         :system
set :rvm_ruby_version, '2.0.0-p247'

# Execute bundled binaries with 'bundle exec', execute global ruby binaries with 'rvm x.x.x do':
SSHKit.config.command_map = Hash.new do |hash, key|
  rvm_prepend     = "#{fetch(:rvm_path)}/bin/rvm #{fetch(:rvm_ruby_version)} do"
  bundle_prepend  = "bundle exec"
  
  if %w{rails rake}.include?(key.to_s)
    hash[key] = "#{rvm_prepend} #{bundle_prepend} #{key}"
  elsif %w{erb bundle}.include?(key.to_s)
    hash[key] = "#{rvm_prepend} #{key}"
  else
    hash[key] = key
  end
end

# Capistrano:
set :format,    :pretty
set :log_level, :debug

# Shared files/dirs:
set :linked_files, %w{config/database.yml}
set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence do
      # Restart Passenger by touching tmp/restart.txt:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end
  
  after :finishing, 'deploy:cleanup'
end