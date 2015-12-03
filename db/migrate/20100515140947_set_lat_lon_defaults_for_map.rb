class SetLatLonDefaultsForMap < ActiveRecord::Migration
  def self.up
    change_column_default(:maps, :lat, 46.753)
    change_column_default(:maps, :lon, -123.436)
  end

  def self.down
    change_column_default(:maps, :lat, nil)
    change_column_default(:maps, :lon, nil)
  end
end
