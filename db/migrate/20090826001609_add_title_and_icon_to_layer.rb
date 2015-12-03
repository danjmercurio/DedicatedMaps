class AddTitleAndIconToLayer < ActiveRecord::Migration
  def self.up
    add_column :layers, :title, :string
    add_column :layers, :icon, :string
  end

  def self.down
    remove_column :layers, :icon
    remove_column :layers, :title
  end
end
