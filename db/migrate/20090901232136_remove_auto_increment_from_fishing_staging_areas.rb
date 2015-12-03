class RemoveAutoIncrementFromFishingStagingAreas < ActiveRecord::Migration
  def self.up
    
  create_table "staging_areas", :force => true, :id => false, :primary_key => :id do |t|
    t.integer "id"
    t.string   "name"
    t.integer  "company_id"
    t.string   "contact"
    t.string   "address"
    t.string   "city"
    t.string   "phone"
    t.string   "fac"
    t.string   "state"
    t.string   "zip"
    t.string   "email"
    t.decimal  "lat"
    t.decimal  "lon"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "specifications"
  end

  create_table "staging_area_assets", :force => true, :id => false, :primary_key => :id  do |t|
    t.integer "id"
    t.integer  "location_id"
    t.integer  "asset_type_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.string   "boom_length"
    t.string   "recovery"
    t.string   "liquid_storage"
    t.string   "ident"
    t.string   "parent_ident"
    t.string   "requirements"
    t.string   "serial_number"
    t.string   "model_name"
    t.string   "manufacture_year"
    t.string   "image"
  end
  
  create_table "fishing_area_points", :force => true, :id => false, :primary_key => :id   do |t|
    t.integer "id"
    t.integer  "map_area_id"
    t.float    "lat"
    t.float    "lon"
  end

  create_table "fishing_area_types", :force => true, :id => false, :primary_key => :id  do |t|
    t.integer "id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "fishing_areas", :force => true, :id => false, :primary_key => :id  do |t|
    t.integer "id"
    t.string   "name"
    t.integer  "area_category_id"
    t.string   "line_type"
    t.float    "lat"
    t.float    "lon"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

    
  end

  def self.down

create_table "staging_areas", :force => true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.string   "contact"
    t.string   "address"
    t.string   "city"
    t.string   "phone"
    t.string   "fac"
    t.string   "state"
    t.string   "zip"
    t.string   "email"
    t.decimal  "lat"
    t.decimal  "lon"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "specifications"
  end

  create_table "staging_area_assets", :force => true  do |t|
    t.integer  "location_id"
    t.integer  "asset_type_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.string   "boom_length"
    t.string   "recovery"
    t.string   "liquid_storage"
    t.string   "ident"
    t.string   "parent_ident"
    t.string   "requirements"
    t.string   "serial_number"
    t.string   "model_name"
    t.string   "manufacture_year"
    t.string   "image"
  end
  
  create_table "fishing_area_points", :force => true do |t|
    t.integer  "map_area_id"
    t.float    "lat"
    t.float    "lon"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fishing_area_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "fishing_areas", :force => true do |t|
    t.string   "name"
    t.integer  "area_category_id"
    t.string   "line_type"
    t.float    "lat"
    t.float    "lon"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end


  end
end
