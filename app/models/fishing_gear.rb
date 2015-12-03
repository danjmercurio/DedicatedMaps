# == Schema Information
# Schema version: 20100727173851
#
# Table name: fishing_gear
#
#  id    :integer         primary key
#  name  :string(255)
#  title :string(255)
#  code  :integer
#

class FishingGear < ActiveRecord::Base
  has_many :fishing_trip_gear
  has_many :fishing_trips, :through => :fishing_trip_gear
end
