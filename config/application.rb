require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

VERSION = File.read('VERSION')
module SwIndexerService
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de


    config.autoload_paths += %W(#{config.root}/lib)
    config.app_version = VERSION # read from VERSION file at base of website
    config.app_name = 'SearchWorks-Indexing-Service'
    config.solr_config_file_path = "#{config.root}/config/solr.yml"
    DiscoveryIndexer::PURL_DEFAULT='https://purl.stanford.edu'
    config.dor_fetcher_url = 'https://dorfetcher-prod.stanford.edu'
  end
end
