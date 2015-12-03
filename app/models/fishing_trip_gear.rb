# == Schema Information
# Schema version: 20100727173851
#
# Table name: fishing_trip_gear
#
#  id              :integer         primary key
#  fishing_trip_id :integer
#  fishing_gear_id :integer
#

class FishingTripGear < ActiveRecord::Base
  belongs_to :fishing_gear
  belongs_to :fishing_trips
end
