source 'https://rubygems.org'

# Rails 4 stable
gem 'rails' #, :git => 'git://github.com/rails/rails.git'

# Rails 3.2 branch
# gem 'rails', :github => 'rails/rails', :branch => '3-2-stable'

gem 'mysql2'
# Important! mysql2 gem version must be 0.3.x && < 0.4 to work with rails 3.2!
#gem 'mysql2', '~> 0.3.18' #:git => 'git://github.com/brianmario/mysql2.git'

# Backwards compatibility with older Prototype functions
gem 'responders'


# gem 'bootstrap'
# source 'https://rails-assets.org' do
#   gem 'rails-assets-tether', '>= 1.1.0'
# end
#gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git' (no longer used, loaded in with MaxCDN)

# Gems used only for assets and not required
# in production environments by default.
gem 'sass-rails'

gem 'execjs'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer'
gem 'uglifier'

# Gems for backward compatibility with rails 3
gem 'protected_attributes'
gem 'rails-observers'
gem 'actionpack-page_caching'
gem 'actionpack-action_caching'
gem 'activerecord-deprecated_finders'


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
end

# Backburner for asychronous job processing (XML POST to /staging_area_feeds)
gem 'backburner'

# Javascript (no longer used, loaded in with MaxCDN, but keep it for jquery_ujs.js)
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
gem 'paperclip', git: "git://github.com/thoughtbot/paperclip.git"

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

gem 'font-awesome-rails'

