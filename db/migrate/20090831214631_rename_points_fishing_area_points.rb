class RenamePointsFishingAreaPoints < ActiveRecord::Migration
  def self.up
    rename_table :points, :fishing_area_points
  end

  def self.down
    rename_table :fishing_area_points, :points
  end
end