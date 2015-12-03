class CreatePastLocations < ActiveRecord::Migration
  def self.up
    create_table :past_locations do |t|
      t.integer :asset_id
      t.float :lat, :long
      t.timestamp :timestamp
      t.timestamps
    end
  end

  def self.down
    drop_table :past_locations
  end
end
