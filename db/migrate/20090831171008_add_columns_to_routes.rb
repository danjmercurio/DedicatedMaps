class AddColumnsToRoutes < ActiveRecord::Migration
  def self.up
    add_column :routes, :asset_id, :integer
    add_column :routes, :name, :string
    add_column :routes, :description, :text
  end

  def self.down
    remove_column :routes, :description
    remove_column :routes, :name
    remove_column :routes, :asset_id
  end
end
