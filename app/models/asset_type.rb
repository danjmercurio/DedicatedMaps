# == Schema Information
# Schema version: 20100727173851
#
# Table name: asset_types
#
#  id    :integer         primary key
#  name  :string(255)
#  title :text
#  sort  :integer
#

class AssetType < ActiveRecord::Base
  has_many :assets
  has_many :icons
end
