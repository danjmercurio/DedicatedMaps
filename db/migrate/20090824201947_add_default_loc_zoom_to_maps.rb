class AddDefaultLocZoomToMaps < ActiveRecord::Migration
  def self.up
    change_column(:maps, :lat, :float, :default => 45.83)
    change_column(:maps, :long, :float, :default => -122.70)
    change_column(:maps, :zoom, :integer, :default => 10)
  end

  def self.down
    change_column(:maps, :lat, :float)
    change_column(:maps, :long, :float)
    change_column(:maps, :zoom, :integer)
  end
end
