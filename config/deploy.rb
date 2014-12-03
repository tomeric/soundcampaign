require 'whenever/capistrano'

set :application, 'soundcampaign'
set :rails_env,   'production'

# SSH:
set :pty,         true
set :ssh_options, forward_agent: true,
                  auth_methods:  %w{publickey}

# Git:
set :scm,               :git
set :repo_url,          'git@github.com:tomeric/soundcampaign.git'
set :branch,            'master'
set :git_shallow_clone, 1

# Deployment:
set :home_dir,   "/home/deploy"
set :deploy_to,  "#{fetch(:home_dir)}/#{fetch(:application)}"
set :deploy_via, :remote_cache

# RVM config:
set :rvm_type,         :system
set :rvm_ruby_version, '2.1.0'

# Delayed Job:
set :delayed_job_workers, 2

# Execute bundled binaries with 'bundle exec', execute global ruby binaries with 'rvm x.x.x do':
SSHKit.config.command_map = Hash.new do |hash, key|
  rvm_prepend     = "#{fetch(:rvm_path)}/bin/rvm #{fetch(:rvm_ruby_version)} do"
  bundle_prepend  = "bundle exec"
  
  if %w{rails rake script/delayed_job}.include?(key.to_s)
    hash[key] = "#{rvm_prepend} #{bundle_prepend} #{key}"
  elsif %w{erb bundle backup script/unicorn}.include?(key.to_s)
    hash[key] = "#{rvm_prepend} #{key}"
  else
    hash[key] = key
  end
end

# Capistrano:
set :format,    :pretty
set :log_level, :debug

# Shared files/dirs:
set :linked_files, %w{config/database.yml .env}
set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

namespace :deploy do
  desc 'Setup application'
  task :setup do
    invoke 'nginx:setup'
  end
  
  desc 'Restart'
  task :restart do
  end
  
  desc 'Cleanup'
  task :cleanup do
    invoke :'rvm:init'
    on primary(:app) do
      within(release_path) { execute :rake, "honeybadger:deploy TO=#{fetch(:rails_env)} REPO=#{repo_url} USER=#{local_user}" }
    end
  end
  
  desc 'Restart application'
  task :restart_processes do
    invoke 'unicorn:restart'
    invoke 'delayed_job:restart'
    invoke 'nginx:reload'
  end
  
  after :starting,         'deploy:setup'
  after :finishing,        'deploy:cleanup'
  after :'deploy:updated', 'deploy:restart_processes'
end
