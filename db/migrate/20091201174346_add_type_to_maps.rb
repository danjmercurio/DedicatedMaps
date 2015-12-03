class AddTypeToMaps < ActiveRecord::Migration
  def self.up
    add_column :maps, :type, :string
  end

  def self.down
    remove_column :maps, :type
  end
end
