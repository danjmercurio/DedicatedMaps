class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.integer :asset_type_id
      t.integer :location_id
      t.integer :client_id
      t.integer :visibility_id
      t.boolean :is_active
      t.string :common_name
      
      t.timestamps
    end
  end

  def self.down
    drop_table :assets
  end
end
