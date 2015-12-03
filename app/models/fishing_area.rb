# == Schema Information
# Schema version: 20100727173851
#
# Table name: fishing_areas
#
#  id                   :integer         primary key
#  name                 :string(255)
#  fishing_area_type_id :integer
#  line_type            :string(255)
#  lat                  :float
#  lon                  :float
#  color                :string(255)
#  created_at           :timestamp
#  updated_at           :timestamp
#

class FishingArea < ActiveRecord::Base
  belongs_to :fishing_area_type
  has_many :fishing_area_points
end
