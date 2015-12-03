class RenameClientsLayers < ActiveRecord::Migration
  def self.up
    rename_table :clients_layers, :clients_layers_privileges
  end

  def self.down
    rename_table :clients_layers_privileges, :clients_layers
  end
end
