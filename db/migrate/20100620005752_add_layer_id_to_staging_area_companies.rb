class AddLayerIdToStagingAreaCompanies < ActiveRecord::Migration
  def self.up
    add_column :staging_area_companies, :layer_id, :integer
  end

  def self.down
    remove_column :staging_area_companies, :layer_id
  end
end
