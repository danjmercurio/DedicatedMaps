# == Schema Information
# Schema version: 20100727173851
#
# Table name: ships
#
#  id            :integer         primary key
#  asset_id      :integer
#  dim_bow       :decimal(, )
#  dim_stern     :decimal(, )
#  dim_starboard :decimal(, )
#  dim_port      :decimal(, )
#  draught       :decimal(, )
#  destination   :string(255)
#  eta           :timestamp
#  created_at    :timestamp
#  updated_at    :timestamp
#  cog           :float
#  speed         :float
#  at_port       :boolean
#  status        :string(255)
#  icon_id       :integer
#

class Ship < ActiveRecord::Base
  belongs_to :icon
  belongs_to :asset
  
  attr :length, true
  attr :width, true
  
  before_update :check_dims

  # If the user sets the ship width and length, convert these to dim_bow, _stern, etc.
  def check_dims
    
    if (self.length.to_f != 0) 
      self.dim_bow = self.length.to_f/2
      self.dim_stern = self.length.to_f/2
    end

    if (self.width.to_f != 0) 
      self.dim_port = self.width.to_f/2
      self.dim_starboard = self.width.to_f/2
    end
    
    self.length = nil
    self.width = nil
  end
end
