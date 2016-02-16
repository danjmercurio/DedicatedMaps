# noinspection ALL
class MakeDeviceSerialNumberUnique < ActiveRecord::Migration
  def self.up
      add_index(:devices, :serial_number, :unique => true, :name => :unique_serial)
  end

  def self.down
      remove_index(:devices, :serial_number, :unique_serial) 
  end
end
