# == Schema Information
# Schema version: 20100727173851
#
# Table name: aircraft
#
#  id         :integer         primary key
#  asset_id   :integer
#  altitude   :integer
#  icon_id    :integer
#  created_at :timestamp
#  updated_at :timestamp
#

class Aircraft < ActiveRecord::Base
  belongs_to :icons
end
