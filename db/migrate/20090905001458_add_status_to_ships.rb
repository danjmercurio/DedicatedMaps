class AddStatusToShips < ActiveRecord::Migration
  def self.up
    add_column :ships, :status, :integer
  end

  def self.down
    remove_column :ships, :status
  end
end
