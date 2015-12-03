class AddDefaultsToDeactivated < ActiveRecord::Migration
  def self.up
  change_column :clients, :deactivated, :boolean, :default => true
  rename_column :clients, :deactivated, :active
  
  change_column :users, :deactivated, :boolean, :default => true
  rename_column :users, :deactivated, :active
  end

  def self.down
  
  rename_column :users, :active, :deactivated
  change_column :users, :deactivated, :boolean
  
  rename_column :users, :active, :deactivated
  change_column :users, :deactivated, :boolean
  end
end
