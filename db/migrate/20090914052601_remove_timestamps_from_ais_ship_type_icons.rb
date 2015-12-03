class RemoveTimestampsFromAisShipTypeIcons < ActiveRecord::Migration
  def self.up
    remove_column :ais_ship_type_icons, :created_at
    remove_column :ais_ship_type_icons, :updated_at
  end

  def self.down
    change_table :ais_ship_type_icons do |t|
        t.timestamps
    end
  end
end
