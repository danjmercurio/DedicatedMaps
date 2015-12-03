class AddIndicesToStagingAreas < ActiveRecord::Migration
  def self.up
      add_index :staging_areas, :staging_area_company_id
      add_index :staging_area_details, :staging_area_id
      add_index :staging_area_assets, :staging_area_id
      add_index :staging_area_assets, :staging_area_asset_type_id
      add_index :staging_area_asset_details, :staging_area_asset_id
      add_index :staging_area_asset_types, :staging_area_company_id
  end

  def self.down
    remove_index :staging_areas, :staging_area_company_id
    remove_index :staging_area_details, :staging_area_id
    remove_index :staging_area_assets, :staging_area_id
    remove_index :staging_area_assets, :staging_area_asset_type_id
    remove_index :staging_area_asset_details, :staging_area_asset_id
    remove_index :staging_area_asset_types, :staging_area_company_id
  end
end
