# == Schema Information
# Schema version: 20100727173851
#
# Table name: current_locations
#
#  id        :integer         primary key
#  device_id :integer
#  lat       :float
#  lon       :float
#  timestamp :timestamp
#

class CurrentLocation < ActiveRecord::Base
  belongs_to :device, :dependent => :destroy
  has_one :asset, :dependent => :destroy
end
