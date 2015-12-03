# == Schema Information
# Schema version: 20100727173851
#
# Table name: ship_histories
#
#  id                  :integer         primary key
#  speed               :float
#  cog                 :float
#  current_location_id :integer
#  timestamp           :timestamp
#

class ShipHistory < ActiveRecord::Base
  belongs_to :past_location
end
