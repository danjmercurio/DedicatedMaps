class CreateStagingAreaAssets < ActiveRecord::Migration
  def self.up
    create_table :staging_area_assets do |t|
      t.integer :parent_id
      t.integer :location_id
      t.integer :asset_type_id
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :staging_area_assets
  end
end
