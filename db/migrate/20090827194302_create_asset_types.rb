class CreateAssetTypes < ActiveRecord::Migration
  def self.up
    create_table :asset_types do |t|
      t.string :name
      t.text :description
    end
   # AssetType.create(:name => "ship")
   # AssetType.create(:name => "aircraft")
   # AssetType.create(:name => "other")
end
  
  def self.down
    drop_table :asset_types
  end
end
