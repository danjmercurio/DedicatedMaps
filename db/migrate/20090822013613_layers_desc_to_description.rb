class LayersDescToDescription < ActiveRecord::Migration
  def self.up
    rename_column(:layers, :desc, :description)
  end

  def self.down
    rename_column(:layers, :description, :desc)
  end
end
