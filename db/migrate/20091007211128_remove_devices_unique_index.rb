class RemoveDevicesUniqueIndex < ActiveRecord::Migration
  def self.up
    remove_index(:devices, :name => :unique_serial) 
  end
  
  def self.down
    add_index(:devices, :serial_number, :unique => true, :name => :unique_serial)
  end
end