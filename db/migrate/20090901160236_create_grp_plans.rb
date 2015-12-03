class CreateGrpPlans < ActiveRecord::Migration
  def self.up
    create_table :grp_plans do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :grp_plans
  end
end
