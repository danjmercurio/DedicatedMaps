class DropTableLayersMaps < ActiveRecord::Migration
  def self.up
     drop_table :layers_maps
  end

  def self.down
    create_table :layers_maps do |t|
      t.integer :layer_id
      t.integer :map_id
    end
  end
end
