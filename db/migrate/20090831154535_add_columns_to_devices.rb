class AddColumnsToDevices < ActiveRecord::Migration
  def self.up
    add_column :devices, :client_id, :integer
    add_column :devices, :device_type_id, :integer
    add_column :devices, :request_key, :string
    add_column :devices, :serial_number, :string
    add_column :devices, :common_name, :string
    add_column :devices, :is_active, :boolean
  end

  def self.down
    remove_column :devices, :is_active
    remove_column :devices, :common_name
    remove_column :devices, :serial_number
    remove_column :devices, :request_key
    remove_column :devices, :device_type_id
    remove_column :devices, :client_id
  end
end
