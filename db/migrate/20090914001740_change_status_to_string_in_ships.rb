class ChangeStatusToStringInShips < ActiveRecord::Migration
  def self.up
    change_column :ships, :status, :string
  end

  def self.down
   change_column :ships, :status, :integer
  end
end
