# == Schema Information
# Schema version: 20100727173851
#
# Table name: grps
#
#  id             :integer         primary key
#  grp_area_id    :integer
#  strategy       :string(255)
#  lat_string     :string(255)
#  lon_string     :string(255)
#  location_name  :string(255)
#  response       :string(255)
#  boom_length    :string(255)
#  flow_level     :string(255)
#  implementation :string(255)
#  staging_area   :string(255)
#  site_access    :string(255)
#  resource       :string(255)
#  status         :string(255)
#  lat            :float
#  lon            :float
#  created_at     :timestamp
#  updated_at     :timestamp
#  state          :integer
#

class Grp < ActiveRecord::Base
  belongs_to :grp_area
  has_many :grp_booms
end
