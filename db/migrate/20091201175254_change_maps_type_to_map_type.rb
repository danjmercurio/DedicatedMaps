class ChangeMapsTypeToMapType < ActiveRecord::Migration
  def self.up
    rename_column :maps, :type, :map_type
  end

  def self.down
    rename_column :maps, :map_type, :type
  end
end
