class AddClientIdToPastLocations < ActiveRecord::Migration
  def self.up
    add_column :past_locations, :client_id, :integer
  end

  def self.down
    remove_column :past_locations, :client_id
  end
end
