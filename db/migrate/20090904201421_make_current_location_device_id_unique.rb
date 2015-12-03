class MakeCurrentLocationDeviceIdUnique < ActiveRecord::Migration
  def self.up
      add_index(:current_locations, :device_id, :unique => true, :name => :unique_device)
  end

  def self.down
      remove_index(:current_locations, :device_id, :unique_device) 
  end
end
