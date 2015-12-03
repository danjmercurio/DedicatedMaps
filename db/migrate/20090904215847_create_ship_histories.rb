class CreateShipHistories < ActiveRecord::Migration
  def self.up
    create_table :ship_histories do |t|
      t.integer :ship_id
      t.float :speed
      t.float :cog

      t.timestamps
    end
  end

  def self.down
    drop_table :ship_histories
  end
end
