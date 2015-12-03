class RenameLayersUsers < ActiveRecord::Migration
    def self.up
      rename_table :layers_users, :layers_users_privileges
    end

    def self.down
      rename_table :layers_users_privileges, :layers_users
    end
end
