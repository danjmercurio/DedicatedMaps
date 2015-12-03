# == Schema Information
# Schema version: 20100727173851
#
# Table name: fishing_crews
#
#  id              :integer         primary key
#  fisherman_id    :integer
#  fishing_trip_id :integer
#

class FishingCrew < ActiveRecord::Base
  belongs_to :fisherman
  belongs_to :fishing_trip
end
