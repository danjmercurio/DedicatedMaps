class ChangeGrpBoomLocTypeToDec < ActiveRecord::Migration
  def self.up
    change_column :grp_booms, :start_lat, :decimal, :precision => 9, :scale => 7
    change_column :grp_booms, :start_lon, :decimal, :precision => 10, :scale => 7
    change_column :grp_booms, :end_lat, :decimal, :precision => 9, :scale => 7
    change_column :grp_booms, :end_lon, :decimal, :precision => 10, :scale => 7
  end

  def self.down
    change_column :grp_booms, :start_lat, :float
    change_column :grp_booms, :start_lon, :float
    change_column :grp_booms, :end_lat, :float
    change_column :grp_booms, :end_lon, :float
  end
end
