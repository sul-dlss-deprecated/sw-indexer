# config valid only for Capistrano 3.4
lock '3.4.0'

set :application, "sw-indexer-service"
set :repo_url, "https://github.com/sul-dlss/sw-indexer-service.git"

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
fetch(:branch)

# Default value for :log_level is :debug
set :log_level, :info

set :stages, %W(staging development production)

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/solr.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle}
