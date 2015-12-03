class CreateGrps < ActiveRecord::Migration
  def self.up
    create_table :grps do |t|
      t.integer :area_id
      t.string :strategy
      t.string :lat_string
      t.string :lon_string
      t.string :location_name
      t.string :response
      t.string :boom_length
      t.string :flow_level
      t.string :inplement
      t.string :staging_area
      t.string :site_access
      t.string :resource
      t.string :status
      t.boolean :is_active
      t.float :lat
      t.float :lon

      t.timestamps
    end
  end

  def self.down
    drop_table :grps
  end
end
