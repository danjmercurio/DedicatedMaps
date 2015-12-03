class RenameAreaCategoriesFishingAreaTypes < ActiveRecord::Migration
  def self.up
    rename_table :area_categories, :fishing_area_types
  end

  def self.down
    rename_table :fishing_area_types, :area_categories
  end
end