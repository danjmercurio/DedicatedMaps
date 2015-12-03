class CreateLicenses < ActiveRecord::Migration
  def self.up
    create_table :licenses do |t|
      t.integer :client_id
      t.integer :user_id
      t.datetime :expires
      t.boolean :deactivate

      t.timestamps
    end
  end

  def self.down
    drop_table :licenses
  end
end
