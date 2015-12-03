class AddTitleToDeviceType < ActiveRecord::Migration
  def self.up
    add_column :device_types, :title, :string
  end

  def self.down
    remove_column :device_types, :title
  end
end
