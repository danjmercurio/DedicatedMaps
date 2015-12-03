class AddColumnsToCurrentLocations < ActiveRecord::Migration
  def self.up
    add_column :current_locations, :device_id, :integer
    add_column :current_locations, :lat, :float
    add_column :current_locations, :long, :float
  end

  def self.down
    remove_column :current_locations, :long
    remove_column :current_locations, :lat
    remove_column :current_locations, :device_id
  end
end
