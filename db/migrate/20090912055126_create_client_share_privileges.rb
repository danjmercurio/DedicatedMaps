class CreateClientSharePrivileges < ActiveRecord::Migration
  def self.up
    create_table :client_share_privileges, :id => false do |t|
      t.integer :sharer_id
      t.integer :recipient_id
    end
  end

  def self.down
    drop_table :client_share_privileges
  end
end
