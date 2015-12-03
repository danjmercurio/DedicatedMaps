# == Schema Information
# Schema version: 20100727173851
#
# Table name: grp_boom_types
#
#  id          :integer         primary key
#  name        :string(255)
#  description :text
#  created_at  :timestamp
#  updated_at  :timestamp
#

class GrpBoomType < ActiveRecord::Base
  has_many :booms
end
