class RenameMapAreaFishingAreas < ActiveRecord::Migration
  def self.up
    rename_table :map_areas, :fishing_areas
  end

  def self.down
    rename_table :fishing_areas, :map_areas
  end
end