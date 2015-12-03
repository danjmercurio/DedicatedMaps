# == Schema Information
# Schema version: 20100727173851
#
# Table name: staging_area_companies
#
#  id         :integer         primary key
#  created_at :timestamp
#  updated_at :timestamp
#  title      :string(255)
#  layer_id   :integer
#

class StagingAreaCompany < ActiveRecord::Base
  has_many :staging_areas
  has_many :staging_area_asset_types
  belongs_to :layer
end
