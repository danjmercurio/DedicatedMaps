class AddCreatedAtToLogins < ActiveRecord::Migration
  def self.up
    add_column :logins, :created_at, :datetime
  end

  def self.down
    remove_column :logins, :created_at
  end
end