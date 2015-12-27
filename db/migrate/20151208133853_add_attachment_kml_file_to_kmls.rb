class AddAttachmentKmlFileToKmls < ActiveRecord::Migration
  def self.up
    change_table :kmls do |t|
      t.attachment :kml_file
    end
  end

  def self.down
    remove_attachment :kmls, :kml_file
  end
end
