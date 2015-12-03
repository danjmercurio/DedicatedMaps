class ChangeInplementToImplementInGrps < ActiveRecord::Migration
  def self.up
    rename_column :grps, :inplement, :implementation
  end

  def self.down
    rename_column :grps, :implementation, :inplement
  end
end