class CreateShipTypeIcons < ActiveRecord::Migration
  def self.up
    create_table :ship_type_icons do |t|
      t.string :ship_type
      t.integer :icon_id

      t.timestamps
    end
  end

  def self.down
    drop_table :ship_type_icons
  end
end
