source 'https://rubygems.org'

gem 'base_indexer', '>= 2.0.0'
gem 'dor-fetcher', '>= 1.1.1'

gem 'rails', '~> 4.2'
gem 'responders', '~> 2.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'config'

gem 'honeybadger', '~> 2.0'

gem 'rubocop', '= 0.37.2', group: [:development, :test] # Update this when 0.38.1 comes out - there was a bug in 0.38.0 with rubocop-rspec
gem 'rubocop-rspec', group: [:development, :test]

group :test do
  gem 'rspec-rails'
  gem 'equivalent-xml'
  gem 'coveralls', require: false
end

group :deployment do
  gem 'capistrano', '~> 3.0'
  gem 'dlss-capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'
  gem 'capistrano-passenger'
end
