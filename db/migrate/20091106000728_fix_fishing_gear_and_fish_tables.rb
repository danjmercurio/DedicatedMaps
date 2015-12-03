class FixFishingGearAndFishTables < ActiveRecord::Migration
  def self.up
    rename_column :fishing_catches, :trip_id, :fishing_trip_id
    rename_column :fishing_trip_gear, :name, :fishing_trip_id
    rename_column :fishing_trip_gear, :title, :fishing_gear_id
    change_column :fishing_trip_gear, :fishing_trip_id, :integer
    change_column :fishing_trip_gear, :fishing_gear_id, :integer
  end

  def self.down
    change_column :fishing_trip_gear, :fishing_gear_id, :string
    change_column :fishing_trip_gear, :fishing_trip_id, :string      
    rename_column :fishing_trip_gear, :fishing_gear_id, :title
    rename_column :fishing_trip_gear, :fishing_trip_id, :name    
    rename_column :fishing_catches, :fishing_trip_id, :trip_id
  end
end
