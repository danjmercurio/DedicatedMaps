class CreateAircrafts < ActiveRecord::Migration
  def self.up
    create_table :aircrafts do |t|
      t.integer :asset_id, :altitude, :icon_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :aircrafts
  end
end
