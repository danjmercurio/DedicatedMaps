# == Schema Information
# Schema version: 20100727173851
#
# Table name: shared_assets
#
#  id        :integer         primary key
#  asset_id  :integer
#  client_id :integer
#

class SharedAsset < ActiveRecord::Base
  belongs_to :asset
  belongs_to :client
end
