class AddStateToClients < ActiveRecord::Migration
  def self.up
      add_column(:clients, :state, :string)
  end

  def self.down
    remove_column(:clients, :state)
  end
end
