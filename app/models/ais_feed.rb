class AisFeed < ActiveRecord::Base

  DEBUG = true # toggle to control log information messages this Controller emits

  # Should this just be a table in the DB?
  STATUS_STRING = {
    0 =>"Underway using Engine",
    1 =>"At Anchor",
    2 =>"Not under Command",
    3 =>"Restricted Maneuverability",
    4 =>"Constrained",
    5 =>"Moored",
    6 =>"Aground",
    7 =>"Engaged in Fishing",
    8 =>"Underway Sailing",
    9 =>"Not defined",
    10 =>"Not defined",
    11 =>"Not defined",
    12 =>"Not defined",
    13 =>"Not defined",
    14 =>"Not defined",
    15 =>"Not defined"
  }
  
  class << self
  
    def ais1=(post_data)
      stored_data = StoredText.create(:text_data => post_data.to_json)
      parse_ais1(post_data, stored_data)
      #AisFeed.send_later(:parse_ais1, stored_data)
    end

    def ais5=(post_data)  
      stored_data = StoredText.create(:text_data => post_data.to_json)
      parse_ais5(post_data, stored_data)
      #AisFeed.send_later(:parse_ais5, stored_data)
    end

    def parse_ais1(post_data, stored_data)
      # AIS 1: 'mmsi' 'lat' 'lon' 'cog' 'speed' 'status' 'time'
      
      ais_type   = DeviceType.find_by_name("ais").id
      visibility = Visibility.find_by_name("Public").id
      asset_type = AssetType.find_by_name('ship').id

      logger.info "AIS 1 Feed: " + post_data.to_s.length.to_s if DEBUG
      post_data.each do |ship_data|
        mmsi = ship_data[0].to_i
        ship_data[1]['mmsi'] = mmsi
        ship_data = ship_data[1]
        device = Device.joins(:assets).where(:serial_number => mmsi)
        if device.count == 1 && device.first.assets.count > 0
          # Handle case where user creates AIS device but doesn't tether to a ship?
          asset = device.first.assets.first
          # If there's an asset on the device, and it's tagged or owned by a client, and not at port, then we record its history
          if asset && (asset.tag || asset.client) && !is_at_port?(ship_data) 
            logger.info 'Saving history: ' + mmsi if DEBUG
            self.record_history(asset) 
          end
        else
          # this is data for a new ship
          asset = self.init_ship(ship_data, ais_type, visibility, asset_type)
          logger.info "New ship: " + asset.id.to_s if DEBUG
        end
        raise Exception('Unable to update ship location') unless self.update_ship_location(asset, ship_data) #if asset
        logger.info 'Updated: ' + mmsi.to_s if DEBUG
      end

      # Clear old ships:
      # If a ship is public, not tagged, and hasn't updated in 24 hours, remove it from the database.
      # i.e. Ships.public.not_tagged.not_at_port.last_update > 24 hours
      # assets_to_delete = Asset.joins(:current_location).all.map {|a|asse
      #    a.tag.nil? && !a.current_location.timestamp.nil? && (a.current_location.timestamp < Time.zone.now - 1.day)
      # }
      assets_to_delete = Asset.includes(:current_location).where(:asset_type_id => 1).select { |a|
        !a.current_location.timestamp.nil? && time_diff(a.current_location.timestamp, Time.now) > 0 }
      logger.info ["Deleting ships: "] + assets_to_delete
      #assets_to_delete.each {|asset| asset.devices.each(&:destroy); asset.destroy}
      assets_to_delete.each do |x|
        x.delete
      end
      stored_data.destroy
    end

    def parse_ais5(post_data, stored_data)
      # AIS 5: 'mmsi' 'name' 'type' 'bow' 'stern' 'port' 'starboard' 'draught' 'destination' 'eta'
      logger.info "AIS 5 Feed: " + post_data.to_s.length.to_s if DEBUG
      post_data.each do |ship_data|
        mmsi = ship_data[0].to_i
        ship_data[1]['mmsi'] = mmsi
        ship_data = ship_data[1]
        ship_data['name'] = 'Anonymous' unless !!ship_data['name']
        ship_data['destination'] = 'Not specified' unless !!ship_data['destination']
        ship_data['mmsi'] = mmsi
        logger.info ship_data['name'] + " Destination: " + ship_data['destination']
        device = Device.joins(:assets).where(:serial_number => mmsi).first
        # We only fill in AIS 5 data if a ship already exists via its AIS 1 feed.
        if device # Use caution with this boolean comparison. It should compare a Device model object, not an ActiveRecord::Relation
          asset = device.assets.first # AIS ships will have one and only one device
          asset && self.record_ship_specs(asset, ship_data)
        end
      end
      stored_data.destroy
    end

    def time_diff(start_time, end_time)
      seconds_diff = (start_time - end_time).to_i.abs

      hours = seconds_diff / 3600
      seconds_diff -= hours * 3600

      minutes = seconds_diff / 60
      seconds_diff -= minutes * 60

      seconds = seconds_diff

      #"#{hours.to_s.rjust(2, '0')}:#{minutes.to_s.rjust(2, '0')}:#{seconds.to_s.rjust(2, '0')}"
      hours
    end

    def record_ship_specs(asset, ship_data)
      ship_data.each do |key, value|
        logger.info key + " = " + value.to_s if DEBUG
        if key == "type"
          if asset.ship
            begin
              icon_id = AisShipTypeIcon.find_by_ship_type_code(value).icon_id || 9
            rescue
              logger.error "Ship type " + value.to_s + " for ship MMSI " + ship_data['mmsi'].to_s + " not found!" if DEBUG
              icon_id = 9 # icon id 9 is "unspecified"
            end
            asset.ship.icon_id = icon_id
          end
        elsif key == "name"
          value = ship_data['mmsi'].to_s if value.blank?
          asset.update_attribute(:common_name, value)
        else
          asset.ship[key] = ship_data[key] unless key == 'mmsi'
        end
      end
      asset.ship.save
    end

    def init_ship(ship_data, ais_type, visibility, asset_type)
      device   = Device.create(:serial_number => ship_data['mmsi'], :device_type_id => ais_type)
      location = CurrentLocation.create(:device => device, :lat => ship_data['lat'], :lon => ship_data['long'], :timestamp => Time.zone.now)
      asset    = Asset.create(:asset_type_id => asset_type, :current_location => location, :visibility_id => visibility, :common_name => ship_data['mmsi'])
      tether   = Tether.create(:asset => asset, :device => device)
      ship     = Ship.create(:asset => asset)
      ship.update_attributes!(:speed => ship_data['speed'], :cog => ship_data['cog'], :status => STATUS_STRING[ship_data['status']])
      return asset
    end

    def is_at_port?(ship_data)
      ship_data['speed'].to_f < 2 # less than 2 m/s
    end

    def record_history(asset)
      cur_loc = asset.current_location
      PastLocation.create(:asset => asset, :lat => cur_loc.lat, :lon => cur_loc.lon, :timestamp => cur_loc.timestamp)
    end

    def update_ship_location(asset, ship_data)
      if ship_data['lat'].to_f == 0 || ship_data['long'].to_f == 0
        logger.info 'Invalid lat/long: %s' % ship_data.inspect if DEBUG
        return
      end
      cur_loc = asset.current_location
      cur_loc.lat = ship_data['lat']
      cur_loc.lon = ship_data['long']
      cur_loc.timestamp = Time.zone.now
      cur_loc.save

      if asset.ship
        ship = asset.ship
        ship.cog = ship_data['cog'] unless ship.at_port # If ship is already at port, don't update its cog
        ship.speed = ship_data['speed']
        ship.at_port = is_at_port?(ship_data)

        ship.status = STATUS_STRING[ship_data['status']]
        ship.save
      end
    end
  end
end
