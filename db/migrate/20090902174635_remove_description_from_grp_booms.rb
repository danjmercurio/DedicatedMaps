class RemoveDescriptionFromGrpBooms < ActiveRecord::Migration
  def self.up
    remove_column :grp_booms, :description
  end

  def self.down
    add_column :grp_booms, :description, :string
  end
end
