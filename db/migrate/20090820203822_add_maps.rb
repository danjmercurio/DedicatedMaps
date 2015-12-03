class AddMaps < ActiveRecord::Migration
  def self.up
    create_table :maps do |t|
      t.integer :user_id
      t.integer :zoom
      t.float :long
      t.float :lat

      t.timestamps
    end
  end

  def self.down
    drop_table :maps
  end
end
