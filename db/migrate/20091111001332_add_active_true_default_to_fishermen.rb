class AddActiveTrueDefaultToFishermen < ActiveRecord::Migration
  def self.up
    change_column :fishermen, :active, :boolean, :default => true
  end

  def self.down
    change_column :fishermen, :active, :boolean
  end
end
