# == Schema Information
# Schema version: 20100727173851
#
# Table name: other
#
#  id            :integer         primary key
#  asset_id      :integer
#  icon_id       :integer
#

class Other < ActiveRecord::Base
  belongs_to :icon
  belongs_to :asset
end