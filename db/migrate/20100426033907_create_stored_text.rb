class CreateStoredText < ActiveRecord::Migration
  def self.up
    create_table :stored_texts do |t|
      t.text :text_data
    end
  end

  def self.down
    drop_table :stored_texts
  end
end
