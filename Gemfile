source 'https://rubygems.org'

# Rails 4 stable
gem 'rails' #, :git => 'git://github.com/rails/rails.git'

gem 'mysql2'
# gem 'mysql2', :git => 'git://github.com/brianmario/mysql2.git'

gem 'devise'
gem 'devise-bootstrap-views'

# Gems used only for assets and not required
# in production environments by default.
gem 'bootstrap-sass'
gem 'sass-rails'
gem 'execjs' # See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'uglifier'

# Gems for backward compatibility with rails 3
gem 'protected_attributes'
gem 'rails-observers'
gem 'actionpack-page_caching'
gem 'actionpack-action_caching'
gem 'activerecord-deprecated_finders'
gem 'responders'


group :development, :test do
  gem "better_errors"
  gem "binding_of_caller"
  gem "meta_request"
  gem "pry-rails"
  gem 'rspec-rails'
  gem 'rails-perftest'
  gem 'single_test' # rake tasks for running tests on single controllers
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'yaml_db'
end

# Backburner for asychronous job processing (XML POST to /staging_area_feeds)
gem 'backburner'

# Javascript
# Note: Not using the asset pipeline for jQuery in views. It's loaded in with MaxCDN.
# Keep this gem for Rails' jQuery_ujs
gem 'jquery-rails'

# gem 'prototype-rails', github: 'rails/prototype-rails', branch: '4.2' # Not using prototype anymore
#
# # support for legacy (Rails 2) prototype helper methods
# gem 'prototype_legacy_helper', '0.0.0', :git => 'git://github.com/rails/prototype_legacy_helper.git'

# Nokogiri for XML parsing
gem 'nokogiri'

# Legacy rails unit tests (rake test)
gem 'test-unit'

# Paperclip for KML/XML file uploads
gem 'paperclip', git: 'git://github.com/thoughtbot/paperclip.git'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

# adds annotate command
# gem 'Annotate', github: 'ctran/annotate_models'

gem 'delayed_job'

gem 'god' # Used to daemonize Backburner process

# This gem is necessary for the development environment on windows
group :development do
  gem 'tzinfo-data'
end
