class RemoveTypeFromStagingAreas < ActiveRecord::Migration
  def self.up
    remove_column :staging_areas, :type
  end

  def self.down
    add_column :staging_areas, :type, :string
  end
end
