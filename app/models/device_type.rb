# == Schema Information
# Schema version: 20100727173851
#
# Table name: device_types
#
#  id          :integer         primary key
#  name        :string(255)     not null
#  title       :string(255)
#  description :text
#

class DeviceType < ActiveRecord::Base
  has_many :devices
end
