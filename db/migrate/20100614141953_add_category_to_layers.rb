class AddCategoryToLayers < ActiveRecord::Migration
  def self.up
    add_column :layers, :category, :string
  end

  def self.down
    remove_column :layers, :category
  end
end
