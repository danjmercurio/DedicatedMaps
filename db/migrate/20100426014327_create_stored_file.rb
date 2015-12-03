class CreateStoredFile < ActiveRecord::Migration
  def self.up
    create_table :stored_files do |t| 
      t.column :description, :string 
      t.column :content_type, :string 
      t.column :filename, :string 
      t.column :binary_data, :binary 
    end 
  end

  def self.down
    drop_table :stored_files
  end
end
