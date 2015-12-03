class MakeShipsAssetIdUnique < ActiveRecord::Migration
  def self.up
      add_index(:ships, :asset_id, :unique => true, :name => :unique_asset)
  end

  def self.down
      remove_index(:ships, :asset_id, :unique_asset) 
  end
end
