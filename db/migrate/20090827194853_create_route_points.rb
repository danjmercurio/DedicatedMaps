class CreateRoutePoints < ActiveRecord::Migration
  def self.up
    create_table :route_points do |t|
      t.integer :asset_id
      t.integer :device_id
    end
  end

  def self.down
    drop_table :route_points
  end
end
