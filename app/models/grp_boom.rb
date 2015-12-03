# == Schema Information
# Schema version: 20100727173851
#
# Table name: grp_booms
#
#  id               :integer         primary key
#  grp_id           :integer
#  grp_boom_type_id :integer
#  start_lat        :decimal(, )
#  start_lon        :decimal(, )
#  end_lat          :decimal(, )
#  end_lon          :decimal(, )
#  created_at       :timestamp
#  updated_at       :timestamp
#  description      :string(255)
#

class GrpBoom < ActiveRecord::Base
  belongs_to :grp
  belongs_to :grp_boom_type
end
