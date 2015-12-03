class ChangeTableNameAssetDetailsToCustomFields < ActiveRecord::Migration
  def self.up
    rename_table(:custom_data, :custom_fields)
  end

  def self.down
    rename_table(:custom_fields, :custom_data)
  end
end
