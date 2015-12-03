class AddClientIdToStoredFile < ActiveRecord::Migration
  def self.up
    add_column :stored_files, :client_id, :integer
  end

  def self.down
    remove_column :stored_files, :client_id
  end
end
