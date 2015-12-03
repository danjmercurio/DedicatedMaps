# == Schema Information
# Schema version: 20100727173851
#
# Table name: past_locations
#
#  id        :integer         primary key
#  asset_id  :integer
#  lat       :float
#  lon       :float
#  timestamp :timestamp
#  client_id :integer
#

class PastLocation < ActiveRecord::Base
  belongs_to :asset
  belongs_to :client
  has_one :ship_history
end
