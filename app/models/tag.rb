# == Schema Information
# Schema version: 20100727173851
#
# Table name: tags
#
#  id         :integer         primary key
#  asset_id   :integer
#  user_id    :integer
#  created_at :timestamp
#  updated_at :timestamp
#

class Tag < ActiveRecord::Base
    belongs_to :user
    belongs_to :asset
end
