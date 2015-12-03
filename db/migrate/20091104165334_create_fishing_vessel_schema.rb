class CreateFishingVesselSchema < ActiveRecord::Migration
  def self.up
    create_table :fishing_vessels do |t|
      t.integer :asset_id
      t.integer :icon_id
      t.float :length
      t.float :width
      t.float :draught
      t.string :call_sign
      t.string :phone
      t.float :cog
      t.float :speed
      t.boolean :at_port
      t.string :port
      t.string :vms_number
      t.string :vms_passcode
      t.string :vms_email
      
      t.timestamps
    end
    
    create_table :fishing_histories do |t|
      t.integer :past_location_id
      t.integer :fishing_trip_id
      t.float :speed
      t.float :cog
    end

    create_table :fishermen do |t|
      t.integer :client_id
      t.boolean :active
      t.string  :first_name
      t.string  :last_name
      t.string  :duties
    end

    create_table :fishing_crews do |t|
      t.integer :fisherman_id
      t.integer :fishing_trip_id
    end

    create_table :fishing_trips do |t|
      t.integer :fishing_vessel_id
      t.string :confirmation
      t.timestamp :date_submitted
      t.timestamp :date_certified
      
      t.timestamps
    end

    create_table :fishing_catches do |t|
      t.integer :fish_id
      t.integer :trip_id
      t.float   :amount
      t.string  :type
      
      t.timestamps
    end

    create_table :fishing_trip_gear do |t|
      t.string :name
      t.string :title
    end

    create_table :fishing_gear do |t|
      t.string :name 
      t.string :title
    end

    create_table :fish do |t|
      t.string :name
      t.string :title
    end

  end

  def self.down
    drop_table :fishing_vessels
    drop_table :fishing_histories
    drop_table :fishermen
    drop_table :fishing_crews
    drop_table :fishing_trips
    drop_table :fishing_catches
    drop_table :fishing_trip_gear
    drop_table :fishing_gear
    drop_table :fish
  end
end
