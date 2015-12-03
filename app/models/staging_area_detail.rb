# == Schema Information
# Schema version: 20100727173851
#
# Table name: staging_area_details
#
#  id              :integer         primary key
#  staging_area_id :integer
#  name            :string(255)
#  value           :string(255)
#

class StagingAreaDetail < ActiveRecord::Base
  belongs_to :staging_area
end
