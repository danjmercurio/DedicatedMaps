# == Schema Information
# Schema version: 20100727173851
#
# Table name: fish
#
#  id    :integer         primary key
#  name  :string(255)
#  title :string(255)
#

class Fish < ActiveRecord::Base
  has_many :intended_catches
  has_many :actual_catches
end
