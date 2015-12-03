class CreateGrpBooms < ActiveRecord::Migration
  def self.up
    create_table :grp_booms do |t|
      t.integer :grp_id
      t.integer :type_id
      t.string :description
      t.float :start_lat
      t.float :start_lon
      t.float :end_lat
      t.float :end_lon

      t.timestamps
    end
  end

  def self.down
    drop_table :grp_booms
  end
end
