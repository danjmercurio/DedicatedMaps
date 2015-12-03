# == Schema Information
# Schema version: 20100727173851
#
# Table name: fishing_histories
#
#  id               :integer         primary key
#  past_location_id :integer
#  fishing_trip_id  :integer
#  speed            :float
#  cog              :float
#

class FishingHistory < ActiveRecord::Base
  belongs_to :past_location
end
