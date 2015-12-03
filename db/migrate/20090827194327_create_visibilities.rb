class CreateVisibilities < ActiveRecord::Migration
  def self.up
    create_table :visibilities do |t|
      t.string :name
      t.text :description
    end
  end

  def self.down
    drop_table :visibilities
  end
end
