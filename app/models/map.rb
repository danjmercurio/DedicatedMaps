# == Schema Information
# Schema version: 20100727173851
#
# Table name: maps
#
#  id         :integer         primary key
#  user_id    :integer
#  zoom       :integer         default(10)
#  lon        :float
#  lat        :float           default(46.753)
#  created_at :timestamp
#  updated_at :timestamp
#  map_type   :string(255)     default("Map"), not null
#

class Map < ActiveRecord::Base
    belongs_to :user
end
