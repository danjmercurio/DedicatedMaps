class AddIconToStagingArea < ActiveRecord::Migration
  def self.up
    add_column :staging_areas, :icon, :string
  end

  def self.down
    remove_column :staging_areas, :icon
  end
end
