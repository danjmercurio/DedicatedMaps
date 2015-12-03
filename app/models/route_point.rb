# == Schema Information
# Schema version: 20100727173851
#
# Table name: route_points
#
#  id        :integer         primary key
#  route_id  :integer
#  lat       :float
#  long      :float
#  timestamp :timestamp
#

class RoutePoint < ActiveRecord::Base
  belongs_to :routes
end
