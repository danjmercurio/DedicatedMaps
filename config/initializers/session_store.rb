# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
# ActionController::Base.session = {
#   :key         => '_ddmaps_session',
#   :secret      => 'fc0fcfbff1dcb544168c5c544e56cb1163775c788790f98aca3d641dd63c74fe96ce2ba492a0abcb37ced915138f07d13c0aaffd1fd9719827968e97c3a594e1'
# }

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

# Rails 3
#Ddmap::Application.config.session_store :active_record_store, :key => '_ddmaps_session'
Ddmap::Application.config.session_store :cookie_store, :key => '_ddmaps_session'
Rails.application.config.cookie_secret = 'fc0fcfbff1dcb544168c5c544e56cb1163775c788790f98aca3d641dd63c74fe96ce2ba492a0abcb37ced915138f07d13c0aaffd1fd9719827968e97c3a594e1'
