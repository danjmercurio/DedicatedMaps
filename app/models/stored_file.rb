# == Schema Information
# Schema version: 20100727173851
#
# Table name: stored_files
#
#  id           :integer         primary key
#  description  :string(255)
#  content_type :string(255)
#  filename     :string(255)
#  binary_data  :binary
#  client_id    :integer
#

class StoredFile < ActiveRecord::Base 

  belongs_to :client
  
  def stored_file= (input_data) 
    self.filename     = input_data.original_filename 
    self.content_type = input_data.content_type.chomp 
    self.binary_data  = input_data.read 
  end 

end
