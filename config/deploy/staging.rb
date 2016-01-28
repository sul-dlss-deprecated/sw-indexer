set :deploy_host, ENV['CAPISTRANO_STAGING_DEPLOY_HOST'] || ask(:deploy_host, 'the server to which you are deploying (do not include .stanford.edu)')
set :user, ENV['CAPISTRANO_STAGING_USER'] || ask(:user, 'username of app account')

set :home_directory, "/opt/app/#{fetch(:user)}"
set :deploy_to, "#{fetch(:home_directory)}/#{fetch(:application)}"

server "#{fetch(:deploy_host)}.stanford.edu", user: fetch(:user), roles: %w(web db app)

Capistrano::OneTimeKey.generate_one_time_key!
set :rails_env, 'production'
