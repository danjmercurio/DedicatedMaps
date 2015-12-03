class ChangeCompanyIdToStagingAreaCompanyId < ActiveRecord::Migration
  def self.up
    rename_column :staging_areas, :company_id, :staging_area_company_id
    rename_column :staging_area_assets, :asset_type_id, :staging_area_asset_type_id
    rename_column :staging_area_asset_types, :company_id , :staging_area_company_id
  end

  def self.down
    rename_column :staging_areas, :staging_area_company_id, :company_id
    rename_column :staging_area_assets, :staging_area_asset_type_id, :asset_type_id
    rename_column :staging_area_asset_types, :staging_area_company_id , :company_id
  end
end
