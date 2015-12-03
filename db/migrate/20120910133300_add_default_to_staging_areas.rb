class AddDefaultToStagingAreas < ActiveRecord::Migration
  def self.up
    change_column :staging_areas, :name, :string, :null => false, :default => 'unknown'
  end

  def self.down
    change_column :staging_areas, :name, :string, :null => true
  end
end
