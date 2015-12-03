# == Schema Information
# Schema version: 20100727173851
#
# Table name: licenses
#
#  id          :integer         primary key
#  client_id   :integer
#  user_id     :integer
#  expires     :timestamp
#  deactivated :boolean
#  created_at  :timestamp
#  updated_at  :timestamp
#

class License < ActiveRecord::Base
  belongs_to :client
  belongs_to :user
end
