# == Schema Information
# Schema version: 20100727173851
#
# Table name: fishing_area_types
#
#  id         :integer         primary key
#  name       :string(255)
#  created_at :timestamp
#  updated_at :timestamp
#

class FishingAreaType < ActiveRecord::Base
  has_many :fishing_areas
end
