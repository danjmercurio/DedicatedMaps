class AddSortToLayers < ActiveRecord::Migration
  def self.up
    add_column :layers, :sort, :integer
  end

  def self.down
    remove_column :layers, :sort
  end
end
