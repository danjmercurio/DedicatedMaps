class EulaDefaultUsers < ActiveRecord::Migration
  def self.up
    #change_table :users do |t|
      change_column :users, :eula, :boolean, :default => false     
    #end
  end

  def self.down
    #change_table :users do |t|
      change_column :users, :eula, :boolean
    #end
  end
end
