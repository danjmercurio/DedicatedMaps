# == Schema Information
# Schema version: 20100727173851
#
# Table name: staging_areas
#
#  id                      :integer         primary key
#  name                    :string(255)
#  staging_area_company_id :integer
#  contact                 :string(255)
#  address                 :string(255)
#  city                    :string(255)
#  phone                   :string(255)
#  fax                     :string(255)
#  state                   :string(255)
#  zip                     :string(255)
#  email                   :string(255)
#  lat                     :decimal(, )
#  lon                     :decimal(, )
#  access_id               :integer
#  icon                    :string(255)
#

class Ies < StagingArea
end
