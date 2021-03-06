require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AskSomeone
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.active_job.queue_adapter = :sidekiq
    config.cache_store = :redis_cache_store, {url: 'redis://localhost:6379/0/cache', expires_in: 90.minutes}
    #config.autoload_paths+=[config.root.join('app')]
    config.generators do |g|
      g.framework :rspec,
                      view_specs: false,
                      helper_specs: false,
                      routing_specs: false,
                      request_specs: false,
                      controller_specs: true
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
