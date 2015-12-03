class ChangeStoredText < ActiveRecord::Migration
  def self.up
    # 16777216 to 4294967295 bytes: LONGTEXT
    change_column :stored_texts, :text_data, :text, :limit => 4294967295
  end

  def self.down
    change_column :stored_texts, :text_data, :text, :limit => 65535
  end
end
