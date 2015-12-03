# == Schema Information
# Schema version: 20100727173851
#
# Table name: staging_area_asset_types
#
#  id                      :integer         primary key
#  staging_area_company_id :integer
#  name                    :string(255)
#  created_at              :timestamp
#  updated_at              :timestamp
#  access_id               :integer
#

class StagingAreaAssetType < ActiveRecord::Base
  has_many :staging_area_assets, :dependent => :destroy
  belongs_to :staging_area_company
end
