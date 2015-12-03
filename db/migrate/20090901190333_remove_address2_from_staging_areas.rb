class RemoveAddress2FromStagingAreas < ActiveRecord::Migration
  
  def self.up
    rename_column :staging_areas, :address1, :address
    remove_column :staging_areas, :address2
  end

  def self.down
    rename_column :staging_areas, :address, :address1
    add_column :staging_areas, :address2, :text
  end
end