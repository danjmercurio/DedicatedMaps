class CreateOther < ActiveRecord::Migration
  def self.up
    create_table :others do |t|
      t.integer :asset_id, :icon_id

      t.timestamps
    end
  end

  def self.down
    drop_table :others
  end
end