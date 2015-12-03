# == Schema Information
# Schema version: 20100727173851
#
# Table name: custom_fields
#
#  id         :integer         primary key
#  name       :string(255)
#  value      :text
#  created_at :timestamp
#  updated_at :timestamp
#  asset_id   :integer
#

class CustomField< ActiveRecord::Base
  belongs_to :asset
end
