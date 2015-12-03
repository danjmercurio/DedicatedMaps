class CreateStagingAreaAssetDetails < ActiveRecord::Migration
  def self.up
    create_table :staging_area_asset_details do |t|
      t.integer :staging_area_asset_id
      t.string :name
      t.string :value
    end
  end
  
  def self.down
    drop_table :staging_area_asset_details
  end
end
