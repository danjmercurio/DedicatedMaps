class ChangeStagingAreaLocTypeToDec < ActiveRecord::Migration
  def self.up
    change_column :staging_areas, :lat, :decimal, :precision => 9, :scale => 7
    change_column :staging_areas, :lon, :decimal, :precision => 10, :scale => 7
  end

  def self.down
    change_column :staging_areas, :lat, :float
    change_column :staging_areas, :lon, :float
  end
end
