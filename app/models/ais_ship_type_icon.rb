# == Schema Information
# Schema version: 20100727173851
#
# Table name: ais_ship_type_icons
#
#  id             :integer         primary key
#  ship_type_code :integer
#  icon_id        :integer
#

class AisShipTypeIcon < ActiveRecord::Base
  belongs_to :icon
end
