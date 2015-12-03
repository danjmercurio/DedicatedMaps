class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.integer :asset_id
      t.text :caption

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
