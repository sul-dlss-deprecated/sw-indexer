set :application, 'sw-indexer'
set :repo_url, 'https://github.com/sul-dlss/sw-indexer.git'

# Default branch is :master
set :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, "/opt/app/harvestdor/sw-indexer"

# Default value for :linked_files is []
set :linked_files, %w{config/secrets.yml config/honeybadger.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system config/settings}

# Default value for keep_releases is 5
set :keep_releases, 5

# honeybadger_env otherwise defaults to rails_env
set :honeybadger_env, fetch(:stage)
