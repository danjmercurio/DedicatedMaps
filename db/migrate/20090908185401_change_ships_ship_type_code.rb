class ChangeShipsShipTypeCode < ActiveRecord::Migration
  def self.up
    change_column :ships, :ship_type, :integer
    rename_column :ships, :ship_type, :ship_type_code
  end

  def self.down
    rename_column :ships, :ship_type_code, :ship_type
    change_column :ships, :ship_type, :string
  end

end