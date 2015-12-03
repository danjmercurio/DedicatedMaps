class RemoveNameFromStagingAreaCompany < ActiveRecord::Migration
  def self.up
    remove_column :staging_area_companies, :name
  end

  def self.down
    add_column :staging_area_companies, :name, :string
  end
end
