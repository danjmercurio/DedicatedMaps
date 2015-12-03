class CreateSharedAssets < ActiveRecord::Migration
  def self.up
    create_table :shared_assets, :id => false do |t|
      t.integer :asset_id
      t.integer :client_id
    end
  end

  def self.down
    drop_table :shared_assets
  end
end
