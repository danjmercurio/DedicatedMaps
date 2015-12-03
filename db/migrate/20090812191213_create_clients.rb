class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.string :company_name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :zip
      t.string :company_url
      t.string :contact_name
      t.string :contact_phone
      t.string :contact_email
      t.text :contact_notes
      t.boolean :deactivated

      t.timestamps
    end
  end

  def self.down
    drop_table :clients
  end
end
