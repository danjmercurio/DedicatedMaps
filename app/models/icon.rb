# == Schema Information
# Schema version: 20100727173851
#
# Table name: icons
#
#  id            :integer         primary key
#  asset_type_id :integer
#  name          :string(255)
#  suffix        :string(255)
#

class Icon < ActiveRecord::Base
  belongs_to :asset_type
  
  has_many :ais_ship_type_icons
  has_many :aircraft
  has_many :ships
  has_many :fishing_vessels
end
