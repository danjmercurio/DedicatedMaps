class ChangeLocationIDtoStagingAreaIdInStagingAreaAssets < ActiveRecord::Migration
  def self.up
    rename_column :staging_area_assets, :location_id, :staging_area_id
  end

  def self.down
        rename_column :staging_area_assets, :location_id, :staging_area_id
  end
end
