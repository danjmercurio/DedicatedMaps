class CreateStagingAreas < ActiveRecord::Migration
  def self.up
    create_table :staging_areas do |t|
      t.string :name
      t.integer :company_id
      t.string :contact
      t.string :address1
      t.string :address2
      t.string :city
      t.string :phone
      t.string :fac
      t.string :state
      t.string :zip
      t.string :email
      t.decimal :lat, :precision => 11, :scale => 9
      t.decimal :lon, :precision => 11, :scale => 9

      t.timestamps
    end
  end

  def self.down
    drop_table :staging_areas
  end
end
