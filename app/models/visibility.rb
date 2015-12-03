# == Schema Information
# Schema version: 20100727173851
#
# Table name: visibilities
#
#  id          :integer         primary key
#  name        :string(255)
#  description :text
#

class Visibility < ActiveRecord::Base
  has_many :assets
end
