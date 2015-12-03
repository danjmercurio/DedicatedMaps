# == Schema Information
# Schema version: 20100727173851
#
# Table name: fish
#
#  id    :integer         primary key
#  name  :string(255)
#  title :string(255)
#

class IntendedFish < Fish
  has_many :intended_catches
end
