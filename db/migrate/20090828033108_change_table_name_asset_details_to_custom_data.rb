class ChangeTableNameAssetDetailsToCustomData < ActiveRecord::Migration
  def self.up
    rename_table(:asset_details, :custom_data)
  end

  def self.down
    rename_table(:custom_data, :asset_details)
  end
end
