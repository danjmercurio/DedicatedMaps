# == Schema Information
# Schema version: 20100727173851
#
# Table name: staging_area_asset_details
#
#  id                    :integer         primary key
#  staging_area_asset_id :integer
#  name                  :string(255)
#  value                 :string(255)
#

class StagingAreaAssetDetail < ActiveRecord::Base
  belongs_to :staging_area_asset
end
