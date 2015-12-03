# == Schema Information
# Schema version: 20100727173851
#
# Table name: fishing_area_points
#
#  id              :integer         primary key
#  fishing_area_id :integer
#  lat             :float
#  lon             :float
#

class FishingAreaPoint < ActiveRecord::Base
  belongs_to :fishing_area
end
