class AddColumnsToRoutePoints < ActiveRecord::Migration
  def self.up
    add_column :route_points, :route_id, :integer
    add_column :route_points, :lat, :float
    add_column :route_points, :long, :float
    add_column :route_points, :timestamp, :datetime
    remove_column :route_points, :asset_id
    remove_column :route_points, :device_id
  end

  def self.down
    remove_column :route_points, :timestamp
    remove_column :route_points, :long
    remove_column :route_points, :lat
    remove_column :route_points, :route_id
    add_column :route_points, :asset_id, :integer
    add_column :route_points, :device_id, :integer
  end
end
