# == Schema Information
# Schema version: 20100727173851
#
# Table name: grp_plans
#
#  id         :integer         primary key
#  name       :string(255)
#  created_at :timestamp
#  updated_at :timestamp
#

class GrpPlan < ActiveRecord::Base
  has_many :grp_areas
end
