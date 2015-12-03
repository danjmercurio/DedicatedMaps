class AddLoginsTable < ActiveRecord::Migration

def self.up
    create_table :logins do |t|
      t.integer :user_id
    end
end 

  def self.down
      drop_table :logins
    end
    
end