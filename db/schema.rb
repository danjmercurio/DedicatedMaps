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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160318033816) do

  create_table "aircraft", force: :cascade do |t|
    t.integer  "asset_id",   limit: 4
    t.integer  "altitude",   limit: 4
    t.integer  "icon_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aircrafts", force: :cascade do |t|
    t.integer  "asset_id",   limit: 4
    t.integer  "altitude",   limit: 4
    t.integer  "icon_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ais_ship_type_icons", force: :cascade do |t|
    t.integer "ship_type_code", limit: 4
    t.integer "icon_id",        limit: 4
  end

  create_table "area_categories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description", limit: 65535
  end

  create_table "asset_details", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "value",      limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "asset_id",   limit: 4
  end

  create_table "asset_types", force: :cascade do |t|
    t.string  "name",  limit: 255
    t.text    "title", limit: 65535
    t.integer "sort",  limit: 4
  end

  create_table "assets", force: :cascade do |t|
    t.integer  "asset_type_id",       limit: 4
    t.integer  "current_location_id", limit: 4
    t.integer  "client_id",           limit: 4
    t.integer  "visibility_id",       limit: 4
    t.boolean  "is_active",                       default: true
    t.string   "common_name",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "client_share_privileges", id: false, force: :cascade do |t|
    t.integer "sharer_id",    limit: 4
    t.integer "recipient_id", limit: 4
  end

  create_table "clients", force: :cascade do |t|
    t.string   "company_name",  limit: 255
    t.string   "address1",      limit: 255
    t.string   "address2",      limit: 255
    t.string   "city",          limit: 255
    t.string   "zip",           limit: 255
    t.string   "company_url",   limit: 255
    t.string   "contact_name",  limit: 255
    t.string   "contact_phone", limit: 255
    t.string   "contact_email", limit: 255
    t.text     "contact_notes", limit: 65535
    t.boolean  "active",                      default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",         limit: 255
  end

  create_table "clients_layers", id: false, force: :cascade do |t|
    t.integer "client_id", limit: 4
    t.integer "layer_id",  limit: 4
  end

  create_table "clients_layers_privileges", id: false, force: :cascade do |t|
    t.integer "client_id", limit: 4
    t.integer "layer_id",  limit: 4
  end

  create_table "current_locations", force: :cascade do |t|
    t.integer  "device_id", limit: 4
    t.float    "lat",       limit: 24
    t.float    "lon",       limit: 24
    t.datetime "timestamp"
  end

  add_index "current_locations", ["device_id"], name: "unique_device", unique: true, using: :btree

  create_table "custom_fields", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "value",      limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "asset_id",   limit: 4
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "device_types", force: :cascade do |t|
    t.string "name",        limit: 255,   null: false
    t.string "title",       limit: 255
    t.text   "description", limit: 65535
  end

  create_table "devices", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_id",      limit: 4
    t.integer  "device_type_id", limit: 4
    t.string   "request_key",    limit: 255
    t.string   "serial_number",  limit: 255
    t.string   "common_name",    limit: 255
    t.boolean  "is_active",                  default: true
  end

  create_table "faria_feeds", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fish", force: :cascade do |t|
    t.string "name",  limit: 255
    t.string "title", limit: 255
  end

  create_table "fishermen", force: :cascade do |t|
    t.integer "client_id",  limit: 4
    t.boolean "active",                 default: true
    t.string  "first_name", limit: 255
    t.string  "last_name",  limit: 255
    t.string  "duties",     limit: 255
  end

  create_table "fishing_area_points", force: :cascade do |t|
    t.integer "fishing_area_id", limit: 4
    t.float   "lat",             limit: 24
    t.float   "lon",             limit: 24
  end

  create_table "fishing_area_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fishing_areas", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.integer  "fishing_area_type_id", limit: 4
    t.string   "line_type",            limit: 255
    t.float    "lat",                  limit: 24
    t.float    "lon",                  limit: 24
    t.string   "color",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fishing_catches", force: :cascade do |t|
    t.integer  "fish_id",         limit: 4
    t.integer  "fishing_trip_id", limit: 4
    t.float    "amount",          limit: 24
    t.string   "type",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fishing_crews", force: :cascade do |t|
    t.integer "fisherman_id",    limit: 4
    t.integer "fishing_trip_id", limit: 4
  end

  create_table "fishing_gear", force: :cascade do |t|
    t.string  "name",  limit: 255
    t.string  "title", limit: 255
    t.integer "code",  limit: 4
  end

  create_table "fishing_histories", force: :cascade do |t|
    t.integer "past_location_id", limit: 4
    t.integer "fishing_trip_id",  limit: 4
    t.float   "speed",            limit: 24
    t.float   "cog",              limit: 24
  end

  create_table "fishing_trip_gear", force: :cascade do |t|
    t.integer "fishing_trip_id", limit: 4
    t.integer "fishing_gear_id", limit: 4
  end

  create_table "fishing_trips", force: :cascade do |t|
    t.integer  "fishing_vessel_id", limit: 4
    t.string   "confirmation",      limit: 255
    t.datetime "date_submitted"
    t.datetime "date_certified"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fishing_vessels", force: :cascade do |t|
    t.integer  "asset_id",     limit: 4
    t.integer  "icon_id",      limit: 4
    t.float    "length",       limit: 24
    t.float    "width",        limit: 24
    t.float    "draught",      limit: 24
    t.string   "call_sign",    limit: 255
    t.string   "phone",        limit: 255
    t.float    "cog",          limit: 24
    t.float    "speed",        limit: 24
    t.boolean  "at_port"
    t.string   "port",         limit: 255
    t.string   "vms_number",   limit: 255
    t.string   "vms_passcode", limit: 255
    t.string   "vms_email",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grp_areas", force: :cascade do |t|
    t.integer  "grp_plan_id", limit: 4
    t.string   "name",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grp_boom_types", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grp_booms", force: :cascade do |t|
    t.integer  "grp_id",           limit: 4
    t.integer  "grp_boom_type_id", limit: 4
    t.decimal  "start_lat",                    precision: 10
    t.decimal  "start_lon",                    precision: 10
    t.decimal  "end_lat",                      precision: 10
    t.decimal  "end_lon",                      precision: 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description",      limit: 255
  end

  create_table "grp_plans", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grps", force: :cascade do |t|
    t.integer  "grp_area_id",    limit: 4
    t.string   "strategy",       limit: 255
    t.string   "lat_string",     limit: 255
    t.string   "lon_string",     limit: 255
    t.string   "location_name",  limit: 255
    t.string   "response",       limit: 255
    t.string   "boom_length",    limit: 255
    t.string   "flow_level",     limit: 255
    t.string   "implementation", limit: 255
    t.string   "staging_area",   limit: 255
    t.string   "site_access",    limit: 255
    t.string   "resource",       limit: 255
    t.string   "status",         limit: 255
    t.float    "lat",            limit: 24
    t.float    "lon",            limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "state",          limit: 4
  end

  create_table "icons", force: :cascade do |t|
    t.integer "asset_type_id", limit: 4
    t.string  "name",          limit: 255
    t.string  "suffix",        limit: 255
  end

  create_table "images", force: :cascade do |t|
    t.integer  "asset_id",   limit: 4
    t.text     "caption",    limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kmls", force: :cascade do |t|
    t.integer  "layer_id",              limit: 4
    t.string   "label",                 limit: 255
    t.string   "url",                   limit: 255
    t.integer  "sort",                  limit: 4
    t.integer  "active",                limit: 4,   null: false
    t.integer  "stored_file_id",        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "kml_file_file_name",    limit: 255
    t.string   "kml_file_content_type", limit: 255
    t.integer  "kml_file_file_size",    limit: 4
    t.datetime "kml_file_updated_at"
  end

  create_table "layers", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",       limit: 255
    t.string   "icon",        limit: 255
    t.integer  "sort",        limit: 4
    t.string   "category",    limit: 255
  end

  create_table "layers_maps", id: false, force: :cascade do |t|
    t.integer "layer_id", limit: 4
    t.integer "map_id",   limit: 4
  end

  create_table "layers_users", id: false, force: :cascade do |t|
    t.integer "layer_id", limit: 4
    t.integer "user_id",  limit: 4
  end

  create_table "layers_users_privileges", id: false, force: :cascade do |t|
    t.integer "layer_id", limit: 4
    t.integer "user_id",  limit: 4
  end

  create_table "licenses", force: :cascade do |t|
    t.integer  "client_id",   limit: 4
    t.integer  "user_id",     limit: 4
    t.datetime "expires"
    t.boolean  "deactivated"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logins", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.datetime "created_at"
  end

  create_table "map_areas", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.integer  "area_category_id", limit: 4
    t.string   "line_type",        limit: 255
    t.float    "lat",              limit: 24
    t.float    "lon",              limit: 24
    t.string   "color",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "maps", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "zoom",       limit: 4,   default: 10
    t.float    "lon",        limit: 24
    t.float    "lat",        limit: 24,  default: 46.753
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "map_type",   limit: 255, default: "Map",  null: false
  end

  create_table "others", force: :cascade do |t|
    t.integer  "asset_id",   limit: 4
    t.integer  "icon_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "past_locations", force: :cascade do |t|
    t.integer  "asset_id",  limit: 4
    t.float    "lat",       limit: 24
    t.float    "lon",       limit: 24
    t.datetime "timestamp"
    t.integer  "client_id", limit: 4
  end

  create_table "points", force: :cascade do |t|
    t.integer  "map_area_id", limit: 4
    t.float    "lat",         limit: 24
    t.float    "lon",         limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "privileges", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "route_points", force: :cascade do |t|
    t.integer  "route_id",  limit: 4
    t.float    "lat",       limit: 24
    t.float    "long",      limit: 24
    t.datetime "timestamp"
  end

  create_table "routes", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "asset_id",    limit: 4
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
  end

  create_table "sessions", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "ip_address", limit: 255
    t.string   "path",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shared_assets", force: :cascade do |t|
    t.integer "asset_id",  limit: 4
    t.integer "client_id", limit: 4
  end

  create_table "ship_histories", force: :cascade do |t|
    t.float    "speed",               limit: 24
    t.float    "cog",                 limit: 24
    t.integer  "current_location_id", limit: 4
    t.datetime "timestamp"
  end

  create_table "ships", force: :cascade do |t|
    t.integer  "asset_id",      limit: 4
    t.decimal  "dim_bow",                   precision: 10
    t.decimal  "dim_stern",                 precision: 10
    t.decimal  "dim_starboard",             precision: 10
    t.decimal  "dim_port",                  precision: 10
    t.decimal  "draught",                   precision: 10
    t.string   "destination",   limit: 255
    t.datetime "eta"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "cog",           limit: 24
    t.float    "speed",         limit: 24
    t.boolean  "at_port"
    t.string   "status",        limit: 255
    t.integer  "icon_id",       limit: 4
  end

  create_table "staging_area_asset_details", force: :cascade do |t|
    t.integer "staging_area_asset_id", limit: 4
    t.string  "name",                  limit: 255
    t.string  "value",                 limit: 255
  end

  create_table "staging_area_asset_types", force: :cascade do |t|
    t.integer  "staging_area_company_id", limit: 4
    t.string   "name",                    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "access_id",               limit: 4
  end

  create_table "staging_area_assets", force: :cascade do |t|
    t.integer "staging_area_id",            limit: 4
    t.integer "staging_area_asset_type_id", limit: 4
    t.text    "description",                limit: 65535
    t.string  "access_id",                  limit: 255
    t.string  "parent_access_id",           limit: 255
    t.string  "image",                      limit: 255
  end

  create_table "staging_area_companies", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",      limit: 255
    t.integer  "layer_id",   limit: 4
  end

  create_table "staging_area_details", force: :cascade do |t|
    t.integer "staging_area_id", limit: 4
    t.string  "name",            limit: 255
    t.string  "value",           limit: 255
  end

  create_table "staging_areas", force: :cascade do |t|
    t.string  "name",                    limit: 255,                          default: "unknown", null: false
    t.integer "staging_area_company_id", limit: 4
    t.string  "contact",                 limit: 255
    t.string  "address",                 limit: 255
    t.string  "city",                    limit: 255
    t.string  "phone",                   limit: 255
    t.string  "fax",                     limit: 255
    t.string  "state",                   limit: 255
    t.string  "zip",                     limit: 255
    t.string  "email",                   limit: 255
    t.decimal "lat",                                 precision: 10, scale: 7
    t.decimal "lon",                                 precision: 10, scale: 7
    t.integer "access_id",               limit: 4
    t.string  "icon",                    limit: 255
  end

  create_table "stored_files", force: :cascade do |t|
    t.string  "description",  limit: 255
    t.string  "content_type", limit: 255
    t.string  "filename",     limit: 255
    t.binary  "binary_data",  limit: 65535
    t.integer "client_id",    limit: 4
  end

  create_table "stored_texts", force: :cascade do |t|
    t.text "text_data", limit: 4294967295
  end

  create_table "tags", force: :cascade do |t|
    t.integer  "asset_id",   limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tethers", force: :cascade do |t|
    t.integer  "asset_id",   limit: 4
    t.integer  "device_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "visibilities", force: :cascade do |t|
    t.string "name",        limit: 255
    t.text   "description", limit: 65535
  end

  create_table "watchdogs", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
