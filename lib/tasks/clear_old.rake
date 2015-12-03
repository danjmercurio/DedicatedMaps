task :clear_old_ships => :environment do
  # If a ship is public, not at port, not tagged, and hasn't updated in 24 hours, remove it from the database.
  # i.e. Ships.public.not_tagged.not_at_port.last_update > 24 hours
  assets_to_delete = Asset.find_all_by_client_id(nil).select {|a| !a.ship.at_port && a.tag.nil? && a.current_location.timestamp < Time.zone.now - 1.day}
  puts ["Deleting ships: "] + assets_to_delete.map {|a| "MMSI: " + a.devices.first.serial_number + " Name: " + (a.common_name || "")} 
  assets_to_delete.each(&:destroy) 
end
