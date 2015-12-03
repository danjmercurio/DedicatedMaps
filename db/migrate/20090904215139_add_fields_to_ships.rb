class AddFieldsToShips < ActiveRecord::Migration
  def self.up
    add_column :ships, :ship_type, :string
    add_column :ships, :cog, :float
    add_column :ships, :speed, :float
    add_column :ships, :at_port, :boolean
    add_column :ships, :name, :string
    remove_column :ships, :icon_id
  end

  def self.down
    add_column :ships, :icon_id, :boolean
    remove_column :ships, :at_port
    remove_column :ships, :spped
    remove_column :ships, :cog
    remove_column :ships, :ship_type
    remove_column :ships, :name
  end
end
