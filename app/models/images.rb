# == Schema Information
# Schema version: 20100727173851
#
# Table name: images
#
#  id         :integer         primary key
#  asset_id   :integer
#  caption    :text
#  created_at :timestamp
#  updated_at :timestamp
#

class Images < ActiveRecord::Base
  belongs_to :asset
end
