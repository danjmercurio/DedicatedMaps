class CreateLayerMapUserClientHabtms < ActiveRecord::Migration
  def self.up
    create_table :layers_maps do |t|
      t.integer :layer_id
      t.integer :map_id
    end
    create_table :layers_users do |t|
      t.integer :layer_id
      t.integer :user_id
    end
    create_table :clients_layers do |t|
      t.integer :client_id
      t.integer :layer_id
    end
  end

  def self.down
    drop_table :layers_maps
    drop_table :layers_users
    drop_table :clients_layers
  end
end
