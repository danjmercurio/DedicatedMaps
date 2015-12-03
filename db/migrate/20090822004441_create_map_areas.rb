class CreateMapAreas < ActiveRecord::Migration
  def self.up
    create_table :map_areas do |t|
      t.string :name
      t.references :area_category
      t.string :line_type
      t.float :lat
      t.float :lon
      t.string :color

      t.timestamps
    end
  end

  def self.down
    drop_table :map_areas
  end
end
