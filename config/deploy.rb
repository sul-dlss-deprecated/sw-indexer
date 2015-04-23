set :application, "sw-indexer-service"
set :repo_url, "https://github.com/sul-dlss/sw-indexer-service"
set :user, ask("User", 'enter in the app username')

set :home_directory, "/opt/app/#{fetch(:user)}"
set :deploy_to, "#{fetch(:home_directory)}/#{fetch(:application)}"

set :stages, %W(staging development production)

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/solr.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle}

last_tag = `git describe --abbrev=0 --tags`.strip
default_tag='master'
set :tag, ask("Tag to deploy (make sure to push the tag first): [default: #{default_tag}, last tag: #{last_tag}] ", default_tag)

set :branch, fetch(:tag)

set :deploy_host, ask("Server", 'enter in the server you are deploying to. do not include .stanford.edu')
server "#{fetch(:deploy_host)}.stanford.edu", user: fetch(:user), roles: %w{web db app}

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end
  after :publishing, :restart

end

before 'deploy:compile_assets', 'squash:write_revision'