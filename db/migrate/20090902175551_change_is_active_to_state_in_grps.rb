class ChangeIsActiveToStateInGrps < ActiveRecord::Migration
  def self.up
    remove_column :grps, :is_active
    add_column :grps, :state, :integer
  end

  def self.down
    add_column :grps, :is_active, :boolean
    remove_column :grps, :state
  end
end
