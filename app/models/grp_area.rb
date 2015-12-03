# == Schema Information
# Schema version: 20100727173851
#
# Table name: grp_areas
#
#  id          :integer         primary key
#  grp_plan_id :integer
#  name        :string(255)
#  created_at  :timestamp
#  updated_at  :timestamp
#

class GrpArea < ActiveRecord::Base
  belongs_to :grp_plan
  has_many :grps
end
