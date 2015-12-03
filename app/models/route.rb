# == Schema Information
# Schema version: 20100727173851
#
# Table name: routes
#
#  id          :integer         primary key
#  created_at  :timestamp
#  updated_at  :timestamp
#  asset_id    :integer
#  name        :string(255)
#  description :text
#

class Route < ActiveRecord::Base
  belongs_to :asset
  has_many :route_points
end
