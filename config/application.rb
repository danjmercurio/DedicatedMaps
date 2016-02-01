require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env) if defined?(Bundler)

module Ddmap
  class Application < Rails::Application
    config.autoload_paths += [config.root.join('lib')]
    config.encoding = 'utf-8'
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Add additional load paths for your own custom dirs
    #config.load_paths += %W( #{RAILS_ROOT}/jobs )

    # Specify gems that this application depends on and have them installed with rake gems:install

    # config.gem "calendar_date_select"

    # config.gem "bj"
    # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
    # config.gem "sqlite3-ruby", :lib => "sqlite3"
    # config.gem "aws-s3", :lib => "aws/s3"
    #config.gem 'delayed_job', :version => '~>2.0.7'

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Skip frameworks you're not going to use. To use Rails without a database,
    # you must remove the Active Record framework.
    # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

    # Activate observers that should always be running
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names.
    config.time_zone = 'Pacific Time (US & Canada)'
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
    # config.i18n.default_locale = :de

    # scrub passwords from log
    config.filter_parameters += [:password]

    # Disable Rails 4 strong_parameters
    config.action_controller.permit_all_parameters = true
  end
    Backburner.configure do |config|
        config.beanstalk_url       = ["beanstalk://127.0.0.1"]
        config.tube_namespace      = "ddmaps.app.production"
        config.namespace_separator = "."
        config.on_error            = lambda { |e| puts e }
        config.max_job_retries     = 3 # default 0 retries
        config.retry_delay         = 2 # default 5 seconds
        config.retry_delay_proc    = lambda { |min_retry_delay, num_retries| min_retry_delay + (num_retries ** 3) }
        config.default_priority    = 65536
        config.respond_timeout     = 120
        config.default_worker      = Backburner::Workers::Simple
        config.logger              = Logger.new(STDOUT)
        config.primary_queue       = "backburner-jobs"
        config.priority_labels     = { :custom => 50, :useless => 1000 }
        config.reserve_timeout     = nil
    end


end
