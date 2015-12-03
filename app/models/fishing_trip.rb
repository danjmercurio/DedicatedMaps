# == Schema Information
# Schema version: 20100727173851
#
# Table name: fishing_trips
#
#  id                :integer         primary key
#  fishing_vessel_id :integer
#  confirmation      :string(255)
#  date_submitted    :timestamp
#  date_certified    :timestamp
#  created_at        :timestamp
#  updated_at        :timestamp
#

class FishingTrip < ActiveRecord::Base
  belongs_to :fishing_vessel
  
  has_many :fishing_histories
  
  has_many :actual_catches
  has_many :real_fish, :through => :actual_catches, :class_name => "Fish"
  
  has_many :intended_catches
  has_many :fish, :through => :intended_catches
  
  has_many :fishing_trip_gear
  has_many :fishing_gear, :through => :fishing_trip_gear
  
  has_many :fishing_crews
  has_many :fishermen, :through => :fishing_crews    
end
