# == Schema Information
# Schema version: 20100727173851
#
# Table name: fishermen
#
#  id         :integer         primary key
#  client_id  :integer
#  active     :boolean         default(TRUE)
#  first_name :string(255)
#  last_name  :string(255)
#  duties     :string(255)
#

class Fisherman < ActiveRecord::Base
  belongs_to :client
  has_many :fishing_crews
  has_many :fishing_trips, :through => :fishing_crews
end
