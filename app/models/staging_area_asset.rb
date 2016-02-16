# == Schema Information
# Schema version: 20100727173851
#
# Table name: staging_area_assets
#
#  id                         :integer         primary key
#  staging_area_id            :integer
#  staging_area_asset_type_id :integer
#  description                :text
#  access_id                  :string(255)
#  parent_access_id           :string(255)
#  image                      :string(255)
#

class StagingAreaAsset < ActiveRecord::Base
  belongs_to :staging_area
  belongs_to :staging_area_asset_type
  has_many :staging_area_asset_details, :dependent => :destroy


  # Gets children assets, filtered by the staging area, since parent_access_id could have duplicates with different a staging_area_id 
  # One way to do it, but :conditions to filter staging_area_id is annoying due to lack of proc support in rails 2.3
  # TODO: filter to remove children assets that aren't in parent instance's staging_area_id, or figure how to make dynamic :conditions
  has_many :staging_area_assets, :foreign_key => 'parent_access_id', :primary_key => 'access_id'

  # However, this isn't a true ActiveRecord attribute and doesn't work with to_json..
  # def staging_area_assets
  #   StagingAreaAsset.all(:conditions => ['staging_area_id = ? AND parent_access_id = ?', staging_area_id, access_id])
  # end

  # TODO: This is much less effecient than a dynamic has_many :condition
  def children_assets_filter
    staging_area_assets.each_with_index do |child, i|
      if child.staging_area_id != staging_area_id
        staging_area_assets.delete_at(i);
      end
    end 
  end

  alias_method :after_find, :children_assets_filter

end
