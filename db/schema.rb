# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130123012818) do

  create_table "aircraft", :force => true do |t|
    t.integer  "asset_id"
    t.integer  "altitude"
    t.integer  "icon_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ais_ship_type_icons", :force => true do |t|
    t.integer "ship_type_code"
    t.integer "icon_id"
  end

  create_table "asset_types", :force => true do |t|
    t.string  "name"
    t.text    "title"
    t.integer "sort"
  end

  create_table "assets", :force => true do |t|
    t.integer  "asset_type_id"
    t.integer  "current_location_id"
    t.integer  "client_id"
    t.integer  "visibility_id"
    t.boolean  "is_active",           :default => true
    t.string   "common_name"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  create_table "client_share_privileges", :id => false, :force => true do |t|
    t.integer "sharer_id"
    t.integer "recipient_id"
  end

  create_table "clients", :force => true do |t|
    t.string   "company_name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "zip"
    t.string   "company_url"
    t.string   "contact_name"
    t.string   "contact_phone"
    t.string   "contact_email"
    t.text     "contact_notes"
    t.boolean  "active",        :default => true
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "state"
  end

  create_table "clients_layers_privileges", :id => false, :force => true do |t|
    t.integer "client_id"
    t.integer "layer_id"
  end

  create_table "current_locations", :force => true do |t|
    t.integer  "device_id"
    t.float    "lat"
    t.float    "lon"
    t.datetime "timestamp"
  end

  add_index "current_locations", ["device_id"], :name => "unique_device", :unique => true

  create_table "custom_fields", :force => true do |t|
    t.string   "name"
    t.text     "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "asset_id"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.text     "locked_by"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "device_types", :force => true do |t|
    t.string "name"
    t.text   "description"
    t.string "title"
  end

  create_table "devices", :force => true do |t|
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "client_id"
    t.integer  "device_type_id"
    t.string   "request_key"
    t.string   "serial_number"
    t.string   "common_name"
    t.boolean  "is_active",      :default => true
  end

  add_index "devices", ["serial_number"], :name => "index_devices_on_serial_number", :unique => true

  create_table "faria_feeds", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "fish", :force => true do |t|
    t.string "name"
    t.string "title"
  end

  create_table "fishermen", :force => true do |t|
    t.integer "client_id"
    t.boolean "active",     :default => true
    t.string  "first_name"
    t.string  "last_name"
    t.string  "duties"
  end

  create_table "fishing_area_points", :id => false, :force => true do |t|
    t.integer "id"
    t.integer "fishing_area_id"
    t.float   "lat"
    t.float   "lon"
  end

  create_table "fishing_area_types", :id => false, :force => true do |t|
    t.integer  "id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fishing_areas", :id => false, :force => true do |t|
    t.integer  "id"
    t.string   "name"
    t.integer  "fishing_area_type_id"
    t.string   "line_type"
    t.float    "lat"
    t.float    "lon"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fishing_catches", :force => true do |t|
    t.integer  "fish_id"
    t.integer  "fishing_trip_id"
    t.float    "amount"
    t.string   "type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "fishing_crews", :force => true do |t|
    t.integer "fisherman_id"
    t.integer "fishing_trip_id"
  end

  create_table "fishing_gear", :force => true do |t|
    t.string  "name"
    t.string  "title"
    t.integer "code"
  end

  create_table "fishing_histories", :force => true do |t|
    t.integer "past_location_id"
    t.integer "fishing_trip_id"
    t.float   "speed"
    t.float   "cog"
  end

  create_table "fishing_trip_gear", :force => true do |t|
    t.integer "fishing_trip_id"
    t.integer "fishing_gear_id"
  end

  create_table "fishing_trips", :force => true do |t|
    t.integer  "fishing_vessel_id"
    t.string   "confirmation"
    t.datetime "date_submitted"
    t.datetime "date_certified"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "fishing_vessels", :force => true do |t|
    t.integer  "asset_id"
    t.integer  "icon_id"
    t.float    "length"
    t.float    "width"
    t.float    "draught"
    t.string   "call_sign"
    t.string   "phone"
    t.float    "cog"
    t.float    "speed"
    t.boolean  "at_port"
    t.string   "port"
    t.string   "vms_number"
    t.string   "vms_passcode"
    t.string   "vms_email"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "grp_areas", :force => true do |t|
    t.integer  "grp_plan_id"
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "grp_boom_types", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "grp_booms", :force => true do |t|
    t.integer  "grp_id"
    t.integer  "grp_boom_type_id"
    t.decimal  "start_lat",        :precision => 9,  :scale => 7
    t.decimal  "start_lon",        :precision => 10, :scale => 7
    t.decimal  "end_lat",          :precision => 9,  :scale => 7
    t.decimal  "end_lon",          :precision => 10, :scale => 7
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.string   "description"
  end

  create_table "grp_plans", :id => false, :force => true do |t|
    t.integer  "id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grps", :force => true do |t|
    t.integer  "grp_area_id"
    t.string   "strategy"
    t.string   "lat_string"
    t.string   "lon_string"
    t.string   "location_name"
    t.string   "response"
    t.string   "boom_length"
    t.string   "flow_level"
    t.string   "implementation"
    t.string   "staging_area"
    t.string   "site_access"
    t.string   "resource"
    t.string   "status"
    t.float    "lat"
    t.float    "lon"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "state"
  end

  create_table "icons", :force => true do |t|
    t.integer "asset_type_id"
    t.string  "name"
    t.string  "suffix"
  end

  create_table "images", :force => true do |t|
    t.integer  "asset_id"
    t.text     "caption"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "kmls", :force => true do |t|
    t.integer  "layer_id"
    t.string   "label"
    t.string   "url"
    t.integer  "sort"
    t.integer  "active",         :null => false
    t.integer  "stored_file_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "layers", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "title"
    t.string   "icon"
    t.integer  "sort"
    t.string   "category"
  end

  create_table "layers_users_privileges", :id => false, :force => true do |t|
    t.integer "layer_id"
    t.integer "user_id"
  end

  create_table "licenses", :force => true do |t|
    t.integer  "client_id"
    t.integer  "user_id"
    t.datetime "expires"
    t.boolean  "deactivated"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "logins", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
  end

  create_table "maps", :force => true do |t|
    t.integer  "user_id"
    t.integer  "zoom",       :default => 10
    t.float    "lon",        :default => -123.436
    t.float    "lat",        :default => 46.753
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "map_type",   :default => "Map"
  end

  create_table "others", :force => true do |t|
    t.integer  "asset_id"
    t.integer  "icon_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "past_locations", :force => true do |t|
    t.integer  "asset_id"
    t.float    "lat"
    t.float    "lon"
    t.datetime "timestamp"
    t.integer  "client_id"
  end

  create_table "privileges", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "route_points", :force => true do |t|
    t.integer  "route_id"
    t.float    "lat"
    t.float    "long"
    t.datetime "timestamp"
  end

  create_table "routes", :force => true do |t|
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "asset_id"
    t.string   "name"
    t.text     "description"
  end

  create_table "sessions", :force => true do |t|
    t.integer  "user_id"
    t.string   "ip_address"
    t.string   "path"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "shared_assets", :force => true do |t|
    t.integer "asset_id"
    t.integer "client_id"
  end

  create_table "ship_histories", :force => true do |t|
    t.float    "speed"
    t.float    "cog"
    t.integer  "current_location_id"
    t.datetime "timestamp"
  end

  create_table "ships", :force => true do |t|
    t.integer  "asset_id"
    t.decimal  "dim_bow",       :precision => 5, :scale => 1
    t.decimal  "dim_stern",     :precision => 5, :scale => 1
    t.decimal  "dim_starboard", :precision => 5, :scale => 1
    t.decimal  "dim_port",      :precision => 5, :scale => 1
    t.decimal  "draught",       :precision => 5, :scale => 1
    t.string   "destination"
    t.datetime "eta"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.float    "cog"
    t.float    "speed"
    t.boolean  "at_port"
    t.string   "status"
    t.integer  "icon_id"
  end

  add_index "ships", ["asset_id"], :name => "unique_asset", :unique => true

  create_table "staging_area_asset_details", :force => true do |t|
    t.integer "staging_area_asset_id"
    t.string  "name"
    t.string  "value"
  end

  add_index "staging_area_asset_details", ["staging_area_asset_id"], :name => "index_staging_area_asset_details_on_staging_area_asset_id"

  create_table "staging_area_asset_types", :id => false, :force => true do |t|
    t.integer  "id"
    t.integer  "staging_area_company_id"
    t.string   "name"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "access_id"
  end

  add_index "staging_area_asset_types", ["staging_area_company_id"], :name => "index_staging_area_asset_types_on_staging_area_company_id"

  create_table "staging_area_assets", :id => false, :force => true do |t|
    t.integer  "id"
    t.integer  "staging_area_id"
    t.integer  "staging_area_asset_type_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "boom_length"
    t.string   "recovery"
    t.string   "liquid_storage"
    t.string   "access_id"
    t.string   "parent_access_id"
    t.string   "requirements"
    t.string   "serial_number"
    t.string   "model_name"
    t.string   "manufacture_year"
    t.string   "image"
    t.string   "specification"
  end

  add_index "staging_area_assets", ["staging_area_asset_type_id"], :name => "index_staging_area_assets_on_staging_area_asset_type_id"
  add_index "staging_area_assets", ["staging_area_id"], :name => "index_staging_area_assets_on_staging_area_id"

  create_table "staging_area_companies", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "title"
    t.integer  "layer_id"
  end

  create_table "staging_area_details", :force => true do |t|
    t.integer "staging_area_id"
    t.string  "name"
    t.string  "value"
  end

  add_index "staging_area_details", ["staging_area_id"], :name => "index_staging_area_details_on_staging_area_id"

  create_table "staging_areas", :id => false, :force => true do |t|
    t.integer  "id"
    t.string   "name",                                                   :default => "unknown", :null => false
    t.integer  "staging_area_company_id"
    t.string   "contact"
    t.string   "address"
    t.string   "city"
    t.string   "phone"
    t.string   "fax"
    t.string   "state"
    t.string   "zip"
    t.string   "email"
    t.decimal  "lat",                     :precision => 9,  :scale => 7
    t.decimal  "lon",                     :precision => 10, :scale => 7
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "specifications"
    t.integer  "access_id"
    t.string   "icon"
  end

  add_index "staging_areas", ["staging_area_company_id"], :name => "index_staging_areas_on_staging_area_company_id"

  create_table "stored_files", :force => true do |t|
    t.string  "description"
    t.string  "content_type"
    t.string  "filename"
    t.binary  "binary_data"
    t.integer "client_id"
  end

  create_table "stored_texts", :force => true do |t|
    t.text "text_data", :limit => 2147483647
  end

  create_table "tags", :force => true do |t|
    t.integer  "asset_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tethers", :force => true do |t|
    t.integer  "asset_id"
    t.integer  "device_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.integer  "client_id"
    t.integer  "privilege_id"
    t.string   "username"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.boolean  "active",          :default => true
    t.boolean  "eula",            :default => false
    t.datetime "last_login"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "time_zone"
  end

  create_table "visibilities", :force => true do |t|
    t.string "name"
    t.text   "description"
  end

  create_table "watchdogs", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
