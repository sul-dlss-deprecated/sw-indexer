server "sw-indexing-prod.stanford.edu", user: "harvestdor", roles: %w{web db app}

Capistrano::OneTimeKey.generate_one_time_key!
set :rails_env, 'production'
