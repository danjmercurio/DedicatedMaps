class RenameShipTypeIconsTable < ActiveRecord::Migration
  def self.up
    rename_table :ship_type_icons, :ais_ship_type_icons
  end

  def self.down
    rename_table :ais_ship_type_icons, :ship_type_icons
  end
end
