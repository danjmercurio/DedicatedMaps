class CreateGrpAreas < ActiveRecord::Migration
  def self.up
    create_table :grp_areas do |t|
      t.integer :plan_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :grp_areas
  end
end
