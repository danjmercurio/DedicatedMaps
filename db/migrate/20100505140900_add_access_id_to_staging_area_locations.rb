class AddAccessIdToStagingAreaLocations < ActiveRecord::Migration
  def self.up
    add_column :staging_areas, :access_id, :integer
    add_column :staging_area_asset_types, :access_id, :integer
  end

  def self.down
    remove_column :staging_areas, :access_id
    remove_column :staging_area_asset_types, :access_id
  end
end
