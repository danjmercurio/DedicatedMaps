# == Schema Information
# Schema version: 20100727173851
#
# Table name: tethers
#
#  id         :integer         primary key
#  asset_id   :integer
#  device_id  :integer
#  created_at :timestamp
#  updated_at :timestamp
#

class Tether < ActiveRecord::Base
  belongs_to :asset
  belongs_to :device
end
