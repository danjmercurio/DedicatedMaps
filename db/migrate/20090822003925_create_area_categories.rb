class CreateAreaCategories < ActiveRecord::Migration
  def self.up
    create_table :area_categories do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :area_categories
  end
end
