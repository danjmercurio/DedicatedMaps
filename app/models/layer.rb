# == Schema Information
# Schema version: 20100727173851
#
# Table name: layers
#
#  id          :integer         primary key
#  name        :string(255)
#  description :text
#  created_at  :timestamp
#  updated_at  :timestamp
#  title       :string(255)
#  icon        :string(255)
#  sort        :integer
#  category    :string(255)
#


class Layer < ActiveRecord::Base
  has_and_belongs_to_many :clients, :join_table => :clients_layers_privileges
  has_and_belongs_to_many :users, :join_table => :layers_users_privileges
  has_one :staging_area_company
  has_many :kmls

  validates_uniqueness_of :name, :message => "is already used by another layer"

  def self.categories
    ['Custom', 'StagingArea', 'KML']
  end
      
end
