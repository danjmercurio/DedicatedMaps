class CreateCurrentLocations < ActiveRecord::Migration
  def self.up
    create_table :current_locations do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :current_locations
  end
end
