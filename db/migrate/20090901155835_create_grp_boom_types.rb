class CreateGrpBoomTypes < ActiveRecord::Migration
  def self.up
    create_table :grp_boom_types do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :grp_boom_types
  end
end
