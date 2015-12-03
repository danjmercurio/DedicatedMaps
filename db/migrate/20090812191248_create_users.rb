class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :client_id
      t.integer :privilege_id
      t.string :username
      t.string :hashed_password
      t.string :salt
      t.string :first_name
      t.string :last_name
      t.string :email
      t.boolean :deactivated
      t.boolean :eula
      t.datetime :last_login

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
