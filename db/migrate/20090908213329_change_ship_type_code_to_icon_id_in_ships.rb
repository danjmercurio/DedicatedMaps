class ChangeShipTypeCodeToIconIdInShips < ActiveRecord::Migration
  def self.up
    change_table :ships do |t|
      t.remove :ship_type_code
      t.integer :icon_id
    end
  end

  def self.down
    change_table :ships do |t|
      t.integer :ship_type_code
      t.remove :icon_id
    end
  end
end
