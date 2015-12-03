class ChangeAircraftsToAircraft < ActiveRecord::Migration
  def self.up
    rename_table :aircrafts, :aircraft
  end

  def self.down
    rename_table :aircraft, :aircrafts
  end
end
