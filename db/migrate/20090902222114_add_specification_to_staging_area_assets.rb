class AddSpecificationToStagingAreaAssets < ActiveRecord::Migration
  def self.up
    add_column :staging_area_assets, :specification, :string
  end

  def self.down
      remove_column :staging_area_assets, :specification
  end
end
