class ChangeDescriptionToTitleInAssetTypes < ActiveRecord::Migration
  def self.up
    rename_column :asset_types, :description, :title
  end

  def self.down
      rename_column :asset_types, :title, :description
  end
end
