class AddIndexToDeviceSerial < ActiveRecord::Migration
  def self.up
    add_index(:devices, :serial_number, :unique => true)
  end

  def self.down
    remove_index(:devices, :serial_number)
  end
end
