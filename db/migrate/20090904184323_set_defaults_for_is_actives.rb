class SetDefaultsForIsActives < ActiveRecord::Migration
  def self.up
    change_column :devices, :is_active, :boolean, :default => true
    change_column :assets, :is_active, :boolean, :default => true
  end

  def self.down
    change_column :devices, :is_active, :boolean
    change_column :assets, :is_active, :boolean
  end
end
