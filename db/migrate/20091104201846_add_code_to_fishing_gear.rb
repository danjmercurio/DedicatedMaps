class AddCodeToFishingGear < ActiveRecord::Migration
  def self.up
    add_column :fishing_gear, :code, :integer
  end

  def self.down
    remove_column :fishing_gear, :code
  end
end
