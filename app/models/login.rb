# == Schema Information
# Schema version: 20100727173851
#
# Table name: logins
#
#  id         :integer         primary key
#  user_id    :integer
#  created_at :timestamp
#

class Login < ActiveRecord::Base
  belongs_to :user
end
