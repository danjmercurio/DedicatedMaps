# == Schema Information
# Schema version: 20100727173851
#
# Table name: fishing_vessels
#
#  id           :integer         primary key
#  asset_id     :integer
#  icon_id      :integer
#  length       :float
#  width        :float
#  draught      :float
#  call_sign    :string(255)
#  phone        :string(255)
#  cog          :float
#  speed        :float
#  at_port      :boolean
#  port         :string(255)
#  vms_number   :string(255)
#  vms_passcode :string(255)
#  vms_email    :string(255)
#  created_at   :timestamp
#  updated_at   :timestamp
#

class FishingVessel < ActiveRecord::Base
  belongs_to :asset
  belongs_to :icon
  has_many :fishing_trips
  
  def current_trip
    self.fishing_trips.first(:order => "date_certified DESC")
  end
  
end
