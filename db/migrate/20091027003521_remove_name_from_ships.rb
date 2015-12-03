class RemoveNameFromShips < ActiveRecord::Migration
  def self.up
    remove_column :ships, :name
  end

  def self.down
    add_column :ships, :name, :string
  end
end
