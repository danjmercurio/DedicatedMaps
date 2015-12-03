# == Schema Information
# Schema version: 20100727173851
#
# Table name: privileges
#
#  id          :integer         primary key
#  name        :string(255)
#  description :text
#  created_at  :timestamp
#  updated_at  :timestamp
#

class Privilege < ActiveRecord::Base
  has_many :users
end
