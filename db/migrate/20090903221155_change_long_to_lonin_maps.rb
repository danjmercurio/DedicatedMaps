class ChangeLongToLoninMaps < ActiveRecord::Migration
  def self.up
    rename_column :maps, :long, :lon
  end

  def self.down
    rename_column :maps, :lon, :long
end
end
