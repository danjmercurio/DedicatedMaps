class AddSortToAssetType < ActiveRecord::Migration
  def self.up
    add_column :asset_types, :sort, :integer
  end

  def self.down
    remove_column :asset_types, :sort
  end
end
