# == Schema Information
# Schema version: 20100727173851
#
# Table name: assets
#
#  id                  :integer         primary key
#  asset_type_id       :integer
#  current_location_id :integer
#  client_id           :integer
#  visibility_id       :integer
#  is_active           :boolean         default(TRUE)
#  common_name         :string(255)
#  created_at          :timestamp
#  updated_at          :timestamp
#

class Asset < ActiveRecord::Base

  belongs_to :asset_type
  belongs_to :client
  belongs_to :visibility
  belongs_to :current_location, :dependent => :destroy

  has_many :past_locations, :dependent => :destroy
  has_many :custom_fields, :dependent => :destroy
  has_many :devices, :through => :tethers
  has_many :tethers, :dependent => :destroy
  has_many :routes, :dependent => :destroy
  has_many :images
  has_many :users, :through => :tags
  has_many :shared_assets
  has_many :clients, :through => :shared_assets

  has_one :tag, :dependent => :destroy
  has_one :ship, :dependent => :destroy
  has_one :other, :dependent => :destroy
  has_one :aircraft, :dependent => :destroy
  has_one :fishing_vessel, :dependent => :destroy

  validates_presence_of :common_name

  def constitute
    # Return an object that will be shown in a balloon for this type of asset.
    case self.asset_type.name
      when "ship"
        ship_detail = self.ship
        binding.pry
        ship_detail['name'] = self.common_name
        ship_detail['owner'] = self.client.company_name if self.client != nil
        ship_detail['icon'] = self.ship.icon
        ship_detail['age'] = age(self.current_location.timestamp) + ' ago'
        ship_detail
      when "fishing_vessel"
        #Boat info
        ship_detail = self.fishing_vessel
        ship_detail['name'] = self.common_name
        ship_detail['owner'] = self.client.company_name
        ship_detail['icon'] = self.fishing_vessel.icon
        # Current trip information
        trip = self.fishing_vessel.current_trip
        ship_detail['trip'] = trip
        ship_detail['crew'] = trip.fishermen.all.map {|m| m.first_name + " " + m.last_name + " - " + m.duties}
        ship_detail['gear'] = trip.fishing_gear.all.map {|g| g.title}
        ship_detail['intended'] = trip.intended_catches.all.map {|c| c.fish.title}
        ship_detail['actual'] = trip.intended_catches.all.map {|c| c.fish.title + ": " + (3000+100*(1+rand(100))).to_s}
        ship_detail
      when "other"
        other_detail = self.other
        other_detail['lat'] = self.current_location.lat.to_s
        other_detail['lon'] = self.current_location.lon.to_s
        other_detail['name'] = self.common_name
        other_detail['timestamp'] = Time.zone.parse(self.current_location.timestamp.to_s).strftime('%r %b %d, %Y')
        custom_data = self.custom_fields
        if !custom_data.empty?
          details = {}
          custom_data.each do |detail|
            details[detail.name] = detail.value
          end
        end
        other_detail['details'] = details
        other_detail
    end
  end 

  private

  def age(time)
    age_seconds = Time.zone.now - time
    parts = Array.new
    factors = [['day', 86400],['hr', 3600],['min',60],['sec',1]]
    age = factors.inject(age_seconds) do |memo, factor|
      unit, amount = factor
      value, in_seconds = memo.divmod(amount)
      parts << "#{value} #{unit}" if value != 0
      memo -= value * amount
    end

    parts.join(', ')
  end

end
