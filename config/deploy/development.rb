server 'sw-indexing-dev.stanford.edu', user: 'harvestdor', roles: %w{web app db}

set :bundle_without, %w{deployment test}.join(' ')
set :rails_env, "development"

Capistrano::OneTimeKey.generate_one_time_key!

