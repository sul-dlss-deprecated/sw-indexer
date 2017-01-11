set :application, 'sw-indexer'
set :repo_url, 'https://github.com/sul-dlss/sw-indexer.git'
set :user, 'harvestdor'

# Default branch is :master
set :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :home_directory, "/opt/app/#{fetch(:user)}"
set :deploy_to, "#{fetch(:home_directory)}/#{fetch(:application)}"

# Default value for :linked_files is []
set :linked_files, %w{config/secrets.yml config/honeybadger.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system config/settings}

# Default value for keep_releases is 5
set :keep_releases, 5

# server uses standardized suffix
server "sw-indexing-#{fetch(:stage)}.stanford.edu", user: fetch(:user), roles: %w{web db app}

# honeybadger_env otherwise defaults to rails_env
set :honeybadger_env, "#{fetch(:stage)}"
