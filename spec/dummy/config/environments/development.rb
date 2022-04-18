# Default rails 4+ configurator
target = Rails.application
# Legacy rails 3+ configurator
target = App::Application if Rails::VERSION::MAJOR == 3

target.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  config.cache_classes = false
  config.eager_load = false

  config.assets.enabled = true if Rails::VERSION::MAJOR == 3
  if Rails::VERSION::MAJOR > 4
    config.public_file_server.enabled = true
    config.public_file_server.headers = { 'Cache-Control' => 'public, max-age=3600' }
  else
    config.serve_static_files = true
    config.static_cache_control = 'public, max-age=3600'
  end

  # Show full error reports and disable caching.
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  # config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  config.assets.compile = true
  config.assets.compress = false
  config.assets.digest = false
  config.assets.debug = true
  # config.action_controller.asset_host = "file://#{::Rails.root}/public"
  config.assets.prefix = '/assets'

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Log Settings
  config.colorize_logging = true
  config.log_level = :debug
end
