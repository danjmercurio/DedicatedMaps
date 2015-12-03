class AddSpecificationsToStagingAreaAssets < ActiveRecord::Migration
  def self.up
    add_column :staging_areas, :specifications, :string
  end

  def self.down
    remove_column :staging_areas, :specifications
  end
end
