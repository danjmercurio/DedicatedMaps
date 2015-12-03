class RemoveCompanyIdFromStagingAreaAssets < ActiveRecord::Migration
  def self.up
    remove_column :staging_area_assets, :company_id
  end

  def self.down
    add_column :staging_area_assets, :company_id, :integer
  end
end
