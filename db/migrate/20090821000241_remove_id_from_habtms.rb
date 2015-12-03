class RemoveIdFromHabtms < ActiveRecord::Migration
  def self.up
    remove_column(:layers_users, :id)
    remove_column(:clients_layers, :id)
    remove_column(:layers_maps, :id)
  end

  def self.down
    add_column(:layers_users, :id, :integer)
    add_column(:clients_layers, :id, :integer)
    add_column(:layers_maps, :id, :integer)
  end
end
