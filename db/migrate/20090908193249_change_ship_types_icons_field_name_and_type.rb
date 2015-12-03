class ChangeShipTypesIconsFieldNameAndType < ActiveRecord::Migration
  def self.up
    change_column :ship_type_icons, :ship_type, :integer
    rename_column :ship_type_icons, :ship_type, :ship_type_code
  end

  def self.down
    rename_column :ship_type_icons, :ship_type_code, :ship_type
    change_column :ship_type_icons, :ship_type, :string
  end
end