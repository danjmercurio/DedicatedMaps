class CreateTethers < ActiveRecord::Migration
  def self.up
    create_table :tethers do |t|
      t.integer :asset_id, :device_id
      t.timestamps
    end
  end

  def self.down
    drop_table :tethers
  end
end
