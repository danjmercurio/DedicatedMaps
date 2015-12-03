class CreateShips < ActiveRecord::Migration
  def self.up
    create_table :ships do |t|
      t.integer :asset_id, :icon_id
      t.column(:dim_bow, :decimal, :precision => 5, :scale=> 1)
      t.column(:dim_stern, :decimal,  :precision => 5, :scale=> 1)
      t.column(:dim_starboard, :decimal,  :precision => 5, :scale=> 1)
      t.column(:dim_port, :decimal,  :precision => 5, :scale=> 1)
      t.column(:draught, :decimal,  :precision => 5, :scale=> 1)
      t.string :destination
      t.datetime :eta
      
      t.timestamps
    end
  end

  def self.down
    drop_table :ships
  end
end
