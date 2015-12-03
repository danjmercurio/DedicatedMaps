# == Schema Information
# Schema version: 20100727173851
#
# Table name: fishing_catches
#
#  id              :integer         primary key
#  fish_id         :integer
#  fishing_trip_id :integer
#  amount          :float
#  type            :string(255)
#  created_at      :timestamp
#  updated_at      :timestamp
#

class IntendedCatch < FishingCatch
  belongs_to :fish
end 
