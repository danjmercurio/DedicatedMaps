class CorrectLocationIdNameInAssets < ActiveRecord::Migration
  def self.up
    rename_column :assets, :location_id, :current_location_id
  end

  def self.down
    rename_column :assets, :current_location_id, :location_id
  end
end
