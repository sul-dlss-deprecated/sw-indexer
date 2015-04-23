set :bundle_without, %w{deployment test development}.join(' ')
set :rails_env, "production"

Capistrano::OneTimeKey.generate_one_time_key!