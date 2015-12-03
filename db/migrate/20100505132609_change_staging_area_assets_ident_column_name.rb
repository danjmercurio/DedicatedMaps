class ChangeStagingAreaAssetsIdentColumnName < ActiveRecord::Migration
  def self.up
    rename_column :staging_area_assets, :ident, :access_id
    rename_column :staging_area_assets, :parent_ident, :parent_access_id
  end

  def self.down
    rename_column :staging_area_assets, :access_id, :ident
    rename_column :staging_area_assets, :parent_access_id, :parent_ident 
  end
end
