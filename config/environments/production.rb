# # Settings specified here will take precedence over those in config/environment.rb

# # The production environment is meant for finished, "live" apps.
# # Code is not reloaded between requests
# config.cache_classes = true

# # Full error reports are disabled and caching is turned on
# config.action_controller.consider_all_requests_local = false
# config.action_controller.perform_caching             = true
# config.action_view.cache_template_loading            = true

# # See everything in the log (default is :info)
# config.log_level = :fatal

# # Use a different logger for distributed setups
# # config.logger = SyslogLogger.new

# # Use a different cache store in production
# # config.cache_store = :mem_cache_store

# # Enable serving of images, stylesheets, and javascripts from an asset server
# # config.action_controller.asset_host = "http://assets.example.com"

# # Disable delivery errors, bad email addresses will be ignored
# # config.action_mailer.raise_delivery_errors = false

# ActionController::CgiRequest::DEFAULT_SESSION_OPTIONS[:session_domain] = '.dedicatedmaps.com'

# # Enable threaded mode
# # config.threadsafe!

# rails 2 ^

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

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = true

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.log_level = :debug

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.js_compressor = :uglifier

  # Choose the compressors to use (if any) config.assets.js_compressor  =
  # :uglifier config.assets.css_compressor = :yui
   
  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false
   
  # Generate digests for assets URLs. This is planned for deprecation.
  config.assets.digest = true
   
  # Precompile additional assets (application.js, application.css, and all
  # non-JS/CSS are already added) config.assets.precompile += %w( search.js )

  # Expands the lines which load the assets
  config.assets.debug = false

  #debug remote javascript
  #config.action_view.debug_rjs = true

  config.eager_load = true

  #email stuff
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
