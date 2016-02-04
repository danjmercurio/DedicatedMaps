# Settings specified here will take precedence over those in config/environment.rb

# # In the development environment your application's code is reloaded on
# # every request.  This slows down response time but is perfect for development
# # since you don't have to restart the webserver when you make code changes.
# config.cache_classes = false

# # Log error messages when you accidentally call methods on nil.
# config.whiny_nils = true

# # Show full error reports and disable caching
# config.action_controller.consider_all_requests_local = true
# config.action_view.debug_rjs                         = true
# config.action_controller.perform_caching             = false

# # Don't care if the mailer can't send
# config.action_mailer.raise_delivery_errors = true

Ddmap::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb
  config.log_level = :debug

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Expands the lines which load the assets
  config.assets.debug = true

  #debug remote javascript
  #config.action_view.debug_rjs = true

  #eager loading
  config.eager_load = false

  #mailer
  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              'smtp.gmail.com',
    port:                 587,
    domain:               'dedicatedmaps.com',
    user_name:            'no-reply@dedicatedmaps.com',
    password:             'dmaps_email',
    authentication:       'plain',
    enable_starttls_auto: true  }
end
