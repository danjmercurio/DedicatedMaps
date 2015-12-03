class AddDescriptionsToAreaCategories < ActiveRecord::Migration
  def self.up
    add_column :area_categories, :description, :text
  end

  def self.down
    remove_column :area_categories, :description
  end
end
