# Jan11 2013 - Migration invalid, colums already is created with previous 
# migration. See 20090827194650_create_past_locations.rb
# -Dan Schuman

class AddColumnsToPastLocations < ActiveRecord::Migration
  def self.up
    # add_column :past_locations, :lat, :float
    # add_column :past_locations, :long, :float
  end

  def self.down
    # remove_column :past_locations, :long
    # remove_column :past_locations, :lat
  end
end
