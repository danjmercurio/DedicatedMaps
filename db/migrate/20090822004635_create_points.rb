class CreatePoints < ActiveRecord::Migration
  def self.up
    create_table :points do |t|
      t.references :map_area
      t.float :lat
      t.float :lon

      t.timestamps
    end
  end

  def self.down
    drop_table :points
  end
end
