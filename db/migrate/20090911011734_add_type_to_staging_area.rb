class AddTypeToStagingArea < ActiveRecord::Migration
  def self.up
    add_column :staging_areas, :type, :string
  end

  def self.down
    remove_column :staging_areas, :type
  end
end
