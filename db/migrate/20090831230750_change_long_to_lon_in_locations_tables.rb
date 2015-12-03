class ChangeLongToLonInLocationsTables < ActiveRecord::Migration
  def self.up
    rename_column :past_locations, :long, :lon 
    rename_column :current_locations, :long, :lon
  end

  def self.down
    rename_column :past_locations, :lon, :long 
    rename_column :current_locations, :lon, :long 
  end
end
