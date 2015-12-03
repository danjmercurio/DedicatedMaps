class AddFieldsToStagingAreaAssets < ActiveRecord::Migration
  def self.up
    add_column :staging_area_assets, :company_id, :integer
    add_column :staging_area_assets, :boom_length, :string
    add_column :staging_area_assets, :recovery, :string
    add_column :staging_area_assets, :liquid_storage, :string
    add_column :staging_area_assets, :ident, :string
    add_column :staging_area_assets, :parent_ident, :string
    add_column :staging_area_assets, :requirements, :string
    add_column :staging_area_assets, :serial_number, :string
    add_column :staging_area_assets, :model_name, :string
    add_column :staging_area_assets, :manufacture_year, :string
    add_column :staging_area_assets, :image, :string
    remove_column :staging_area_assets, :parent_id
  end

  def self.down
    remove_column :staging_area_assets, :company_id
    remove_column :staging_area_assets, :image
    remove_column :staging_area_assets, :manufacture_year
    remove_column :staging_area_assets, :model_name
    remove_column :staging_area_assets, :serial_number
    remove_column :staging_area_assets, :requirements
    remove_column :staging_area_assets, :parent_ident
    remove_column :staging_area_assets, :ident
    remove_column :staging_area_assets, :liquid_storage
    remove_column :staging_area_assets, :recovery
    remove_column :staging_area_assets, :boom_length
    add_column :staging_area_assets, :parent_id, :integer
  end
end
