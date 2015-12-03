class CreateKmls < ActiveRecord::Migration
  def self.up
    create_table :kmls do |t|
      t.integer :layer_id
      t.string :label
      t.string :url
      t.integer :sort
      t.integer :active, :null => false
      t.integer :stored_file_id
      
      t.timestamps
    end 
  end

  def self.down
    drop_table :kmls
  end
end
