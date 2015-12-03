class AddAssetIdToAssetDetails < ActiveRecord::Migration
  def self.up
    add_column :asset_details, :asset_id, :integer
  end

  def self.down
    remove_column :asset_details, :asset_id
  end
end
