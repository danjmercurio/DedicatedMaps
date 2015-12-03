class CreateAssetDetails < ActiveRecord::Migration
  def self.up
    create_table :asset_details do |t|
      t.string :name
      t.text :value

      t.timestamps
    end
  end

  def self.down
    drop_table :asset_details
  end
end
