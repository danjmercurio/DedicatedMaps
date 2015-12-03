class CreateStagingAreaAssetTypes < ActiveRecord::Migration
  def self.up
    create_table :staging_area_asset_types do |t|
      t.integer :company_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :staging_area_asset_types
  end
end
