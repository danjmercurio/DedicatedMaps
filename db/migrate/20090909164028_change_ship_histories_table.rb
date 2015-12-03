# PastLocations already has :timestamp -ds 2013 Jan 11

class ChangeShipHistoriesTable < ActiveRecord::Migration
  def self.up
    change_table :past_locations do |t|
        t.remove :created_at
        t.remove :updated_at
        # t.timestamp :timestamp
      end
    
    change_table :ship_histories do |t|
        t.remove :created_at
        t.remove :updated_at
        t.remove :ship_id
        t.integer :current_location_id
        t.timestamp :timestamp
    end 
    
    change_table :current_locations do |t|
        t.remove :created_at
        t.remove :updated_at
        t.timestamp :timestamp
      end
         
  end

  def self.down
   change_table :past_locations do |t|
        t.timestamp :created_at
        t.timestamp :updated_at
        t.remove :timestamp
      end

    change_table :ship_histories do |t|
        t.timestamp :created_at
        t.timestamp :updated_at
        t.integer :ship_id
        t.remove :current_location_id
        t.remove :timestamp
      end 
      
    change_table :current_locations do |t|
        t.timestamp :created_at
        t.timestamp :updated_at
        t.remove :timestamp
      end 
 end
end
