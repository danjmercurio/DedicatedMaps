class ChangeColumnNamesForFishingAreas < ActiveRecord::Migration
  def self.up
    rename_column :fishing_area_points, :map_area_id, :fishing_area_id
    remove_column :fishing_area_types, :description
    rename_column :fishing_areas, :area_category_id, :fishing_area_type_id
  end

  def self.down
    rename_column :fishing_area_points, :fishing_area_id, :map_area_id
    add_column :fishing_area_types, :description, :text
    rename_column :fishing_areas, :fishing_area_type_id, :area_category_id
  end
end
