# == Schema Information
# Schema version: 20100727173851
#
# Table name: kmls
#
#  id             :integer         primary key
#  layer_id       :integer
#  label          :string(255)
#  url            :string(255)
#  sort           :integer
#  active         :integer         not null
#  stored_file_id :integer
#  created_at     :timestamp
#  updated_at     :timestamp
#

class Kml < ActiveRecord::Base
  belongs_to :layer
  belongs_to :stored_file, :dependent => :destroy
end
