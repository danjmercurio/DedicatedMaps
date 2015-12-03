class AddDescriptionToGrpBooms < ActiveRecord::Migration
  def self.up
    add_column :grp_booms, :description, :string
    rename_column :grp_booms, :type_id, :grp_boom_type_id
    rename_column :grps, :area_id, :grp_area_id
    rename_column :grp_areas, :plan_id, :grp_plan_id
  end

  def self.down
    remove_column :grp_booms, :description
    rename_column :grp_booms, :grp_boom_type_id, :type_id
    rename_column :grps, :grp_area_id, :area_id
    rename_column :grp_areas, :grp_plan_id, :plan_id
  end
end
