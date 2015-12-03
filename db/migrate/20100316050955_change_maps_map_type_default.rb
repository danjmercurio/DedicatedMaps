class ChangeMapsMapTypeDefault < ActiveRecord::Migration
  def self.up
    change_column_default(:maps, :map_type, 'Map')
  end

  def self.down
    change_column_default(:maps, :map_type, '"Map"')
  end
end
