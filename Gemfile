source 'https://rubygems.org'

gem 'rails', '~> 5.2.0'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false


gem 'base_indexer', '~> 4.2'
gem 'discovery-indexer', '~> 3.0', '>= 3.1.2'

gem 'responders', '~> 2.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

gem 'config'

gem 'honeybadger', '~> 3.0'
gem 'okcomputer' # for monitoring

gem 'rubocop', group: [:development, :test]
gem 'rubocop-rspec', group: [:development, :test]

gem 'faraday'

group :test do
  gem 'rspec-rails'
  gem 'equivalent-xml'
  gem 'coveralls', require: false
  gem 'webmock'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :deployment do
  gem 'capistrano', '~> 3.0'
  gem 'dlss-capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'
  gem 'capistrano-passenger'
end
