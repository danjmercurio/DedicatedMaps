class AisFeed < ActiveRecord::Base
  
  DEBUG = true # toggle to control information messages this Controller puts out

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
      parse_ais1(stored_data)
      #AisFeed.send_later(:parse_ais1, stored_data)
    end

    def ais5=(post_data)  
      stored_data = StoredText.create(:text_data => post_data.to_json)
      parse_ais5(stored_data)
      #AisFeed.send_later(:parse_ais5, stored_data)
    end

    def parse_ais1(feed)
      # AIS 1: 'mmsi' 'lat' 'lon' 'cog' 'speed' 'status' 'time'
      
      ais_type   = DeviceType.find_by_name("ais").id
      visibility = Visibility.find_by_name("Public").id
      asset_type = AssetType.find_by_name('ship').id
         
      data = ActiveSupport::JSON.decode(feed.text_data)
      logger.info "AIS 1 Feed: " + data.length.to_s if DEBUG
      data.each do |mmsi, ship_data|
        ship_data['mmsi'] = mmsi
        device = Device.find_by_serial_number(mmsi)
        if device
          # Handle case where user creates AIS device but doesn't tether to a ship?
          asset = device.assets.first
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
        self.update_ship_location(asset, ship_data) if asset
        logger.info 'Updated: ' + mmsi if DEBUG
      end
      
      # Clear old ships:
      # If a ship is public, not tagged, and hasn't updated in 24 hours, remove it from the database.
      # i.e. Ships.public.not_tagged.not_at_port.last_update > 24 hours
      assets_to_delete = Asset.find_all_by_client_id(nil).select {|a| 
         a.tag.nil? && !a.current_location.timestamp.nil? && (a.current_location.timestamp < Time.zone.now - 1.day)
      }
      logger.info ["Deleting ships: "] + assets_to_delete.map {|a| "MMSI: " + a.devices.first.serial_number + " Name: " + (a.common_name || "")} if DEBUG
      assets_to_delete.each {|asset| asset.devices.each(&:destroy); asset.destroy}
      feed.destroy
    end

    def parse_ais5(feed)
      # AIS 5: 'mmsi' 'name' 'type' 'bow' 'stern' 'port' 'starboard' 'draught' 'destination' 'eta'
      data = ActiveSupport::JSON.decode(feed.text_data)
      logger.info "AIS 5 Feed: " + data.length.to_s if DEBUG
      data.each do |mmsi, ship_data|
        ship_data['mmsi'] = mmsi
        logger.info ship_data["name"] + " Destination: " + ship_data["destination"] if DEBUG
        device = Device.find_by_serial_number(mmsi)
        if device # we only fill in AIS 5 data if a ship alread exists via its AIS 1 feed.
          asset = device.assets.first # AIS ships will have one and only device
          asset && self.record_ship_specs(asset, ship_data)
        end
      end

      feed.destroy
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
          asset.ship[key] = ship_data[key]
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
      if (ship_data['lat'].to_f == 0 || ship_data['long'].to_f == 0)
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
