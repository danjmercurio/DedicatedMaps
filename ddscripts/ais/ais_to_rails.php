<?php
/***************************************************************************

Copyright (C) Dedicated Maps
www.dedicatedmaps.com
Author:	Dave Miller

File Name: send_to_rails.php
Location: /data_for_rails/ais
Description: 

Database 'railsais' contains the data from the continuous AIS feed. This script runs
every few minutes or so, grabs the data, and updates the rails database with AIS ship
information.

Changelog:

v1.0.0	09-06-09 Dave Miller
	Initial version of file

v1.0.1  10-26-09 Dave Miller
   Set up to detect AIS ships registered by users as devices only (not tethered
   to an asset.)
        
v1.0.2  12-16-09 Dave Miller
   Switch to PostgreSQL.

*****************************************************************************/
// If this script is already running, exit.
preg_match_all('|' . preg_quote(__FILE__) . '|', `ps gx`, $matches);
if (count($matches[0]) > 2) {
  echo('Already running. Exiting...');
  exit();
}
e('Starting...');

// connect to dbs
$ais = @pg_connect('host=localhost dbname=ais user=ddmaps password=mapapp');
if (!$ais) {
  die('Could not connect to db: ' . pg_last_error());
}

$rails = @pg_connect('host=localhost dbname=ddmaps_production user=ddmaps password=mapapp');
if (!$rails) {
  die('Could not connect to db: ' . pg_last_error());
}

// AIS 1
function ais1_to_assoc($row) {
  return array(	
    'mmsi' => $row[0],
    'lat' => $row[1],
    'lon' => $row[2],
    'cog' => $row[3],
    'speed' => $row[4],
    'status' => $row[5],
    'time' => $row[6]
  );
}
$query = "SELECT * FROM ais_1";
$result = pg_query($ais, $query);
$records_to_delete = array();
while ($row = pg_fetch_array($result)) {
  if (array_search($data[0], $records_to_delete) === false) {
    $data = ais1_to_assoc($row);
    if (is_new_ship($rails, $data['mmsi'])) {
      $asset_id = init_ship($rails, $data);
      e('New ship: ' . $asset_id);
    } else {
      $asset_id = get_ship($rails, $data);
      if (!$asset_id) continue; //Case where user creates AIS device but doesn't tether to a ship.
      e("Existing ship: " . $asset_id);
      if ((is_tagged_or_dedicated($rails, $asset_id)) && (!is_at_port($data))) {
        e("record history: asset.id => $asset_id");
        record_history($rails, $asset_id);
      }
    }
    e("update location: asset.id => $asset_id");
    update_ship_location($rails, $asset_id, $data);
    $records_to_delete[] = $data['mmsi'];
  }
}
e("Removing stale ships...");
//remove_stale_ships($rails);

// Remove processed records from ais_1
e("Deleting processed ships...");
if (count($records_to_delete) > 0) {
  $query = 'DELETE FROM ais_1 WHERE mmsi IN (' . implode(',', $records_to_delete) . ')';
  pg_query($ais,$query);
}

e("*** Completed AIS 1 ***");

//AIS 5

function ais5_to_assoc($row) {
  return array(	
    'mmsi' => $row[0],
    'name' => $row[1],
    'type' => $row[2],
    'bow' => $row[3],
    'stern' => $row[4],
    'port' => $row[5],
    'starboard' => $row[6],
    'draught' => $row[7],
    'destination' => $row[8],
    'eta' => $row[9]
  );
}
$query = "SELECT * FROM ais_5";
$result = pg_query($ais, $query);
$records_to_delete = array();
while ($row = pg_fetch_array($result)) {
  if (array_search($row[0], $records_to_delete) === false) {
    $data = ais5_to_assoc($row);
    //print_r($data);
    if (!is_new_ship($rails, $data['mmsi'])) {
      $asset_id = get_ship($rails, $data);
      record_ship_specs($rails, $asset_id, $data);
    }
    $records_to_delete[] = $data['mmsi'];
  }
}

// Remove processed records from ais_5
e("Deleting processed ships...");
if (count($records_to_delete) > 0) {
  $query = 'DELETE FROM ais_5 WHERE mmsi IN (' . implode(',', $records_to_delete) . ')';
  pg_query($ais, $query);
}

e('*** Completed AIS 5 ***');

if(!@pg_close($ais)){ 
    $this->oops("Ais connection close failed."); 
}

if(!@pg_close($rails)){ 
    $this->oops("Rails connection close failed."); 
}

e('Rails updated.');

function remove_stale_ships($db) {
  // If a ship is public, not at port, not tagged, and hasn't updated in 1 hour, remove it from the database.
  
  // Former working MySQL query:  
  // $query = "DELETE FROM ships, assets, current_locations, tethers, devices
  //            USING ships 
  //            INNER JOIN assets ON (assets.id = ships.asset_id) 
  //            INNER JOIN current_locations ON (assets.current_location_id = current_locations.id) 
  //            INNER JOIN tethers ON (assets.id = tethers.asset_id)
  //            INNER JOIN devices ON (current_locations.device_id = devices.id)
  //            LEFT OUTER JOIN tags ON (assets.id = tags.asset_id)
  //            WHERE current_locations.timestamp < DATE_SUB(NOW(),INTERVAL 1 HOUR)
  //            AND ships.at_port = false
  //            AND assets.client_id is null
  //            AND tags.user_id is null
  //            ";
  
  $query = "SELECT assets.id FROM ships, current_locations,
     assets LEFT OUTER JOIN tags ON (tags.asset_id = assets.id)
     WHERE assets.id = ships.asset_id
     AND age(current_locations.timestamp) < interval '1 hour'
     AND ships.at_port = false
     AND assets.client_id is null
     AND tags.user_id is null";


   //$query = "SELECT assets.id FROM assets WHERE assets.client_id is null";
   $result = pg_query($db, $query);
  
   while ($asset = pg_fetch_array($result)) {
      $asset_id = $asset[0];
      //e($asset_id);
     
      $query = "DELETE FROM current_locations USING assets 
               WHERE assets.current_location_id = current_locations.id
               AND assets.id = $asset_id";
      pg_query($db, $query);
      
      $query = "DELETE FROM devices USING tethers
                WHERE devices.id = tethers.device_id
                AND tethers.asset_id = $asset_id";
      pg_query($db, $query);
      
      $query = "DELETE FROM ships WHERE ships.asset_id = $asset_id";
      pg_query($db, $query);

      $query = "DELETE FROM tethers WHERE tethers.asset_id = $asset_id";
      pg_query($db, $query);
      
      $query = "DELETE FROM assets WHERE id = $asset_id";
      pg_query($db, $query);    
  }
  
}

function record_ship_specs($db, $asset_id, $data) {
  $query = "UPDATE ships SET
            icon_id = ais_ship_type_icons.icon_id,
            dim_bow = $data[bow],
            dim_stern = $data[stern],
            dim_port = $data[port],
            dim_starboard = $data[starboard],
            draught =  $data[draught],
            destination = '$data[destination]',
            eta = '$data[eta]',
            updated_at = NOW()
            FROM ais_ship_type_icons
            WHERE asset_id = $asset_id
            AND ais_ship_type_icons.ship_type_code = $data[type];";
  pg_query($db, $query);
  e($query);

  $query = "UPDATE assets SET common_name = '$data[name]' WHERE id = $asset_id;";
  pg_query($db, $query);
  e($query);
}
  
function is_at_port($data) {
  if ($data['speed'] < 0.2) { // less than 2 m/s
    return('true');
  } else {
    return('false');
  }
}

function record_history($db, $asset_id) {
  $query = "INSERT INTO past_locations (asset_id, lat, lon, timestamp)
            SELECT $asset_id, current_locations.lat, current_locations.lon, current_locations.timestamp
            FROM current_locations, assets
            WHERE assets.id = $asset_id
            AND current_locations.id = assets.current_location_id";
  pg_query($db, $query);
  e($query);
}

function is_tagged_or_dedicated($db, $asset_id) {
  $query = "SELECT COUNT(*) FROM tags WHERE asset_id = $asset_id LIMIT 1";
  $result = pg_fetch_array(pg_query($db, $query));
  if ($result[0] > 0) return true;
  
  $query = "SELECT COUNT(*) FROM assets WHERE id = $asset_id AND client_id is not null LIMIT 1";
  $result = pg_fetch_array(pg_query($db, $query));
  if ($result[0] > 0) return true;
  
  return false;
}

function update_ship_location($db, $asset_id, $data) {
  $query= "UPDATE current_locations SET 
           lat = $data[lat],
           lon = $data[lon],
           timestamp = NOW()
           FROM assets
           WHERE assets.id = $asset_id
           AND current_locations.id = assets.current_location_id";
  e($query);              
  pg_query($db, $query);

  // If ship is already at port, don't update its cog
  $query ="SELECT at_port, cog FROM ships WHERE asset_id = $asset_id";
  $result = pg_fetch_array(pg_query($db, $query));
  if ($result['at_port']) {
    $cog = $result['cog'];
  } else {
    $cog = $data['cog'];
  } 
  
  $speed = $data['speed'];

  $is_at_port = is_at_port($data);

  $ais_status = array(
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
  );
 
  $status = $ais_status[$data['status']];

  $query = "UPDATE ships SET 
            at_port = $is_at_port,
            cog = $cog,
            speed = $speed,
            status = '$status',
            updated_at = NOW()
            WHERE asset_id = $asset_id";
  pg_query($db, $query);
  e($query);
}

function get_ship($db, $data) {
  $query = "SELECT assets.id FROM assets
            JOIN tethers ON (assets.id = tethers.asset_id)
            JOIN devices ON (tethers.device_id = devices.id)
            WHERE devices.serial_number = '$data[mmsi]'";
  e($query);
  $result = pg_fetch_array(pg_query($db, $query));
  if (!$result) $result['id'] = 0;
  return $result['id'];
}

function is_new_ship($db, $mmsi) {
  $query = "SELECT id FROM devices WHERE serial_number = '$mmsi'";
  $result = pg_query($db, $query);
  return(pg_num_rows($result) == 0);
}

function init_ship($db, $data) {
  $query = "INSERT INTO devices (serial_number, device_type_id) VALUES ($data[mmsi], 1) RETURNING id";
  $insert_row = pg_fetch_row(pg_query($db, $query));
  $device_id = $insert_row[0];
  e($query);

  $query = "INSERT INTO current_locations (device_id, lat, lon, timestamp)
            VALUES ($device_id, $data[lat], $data[lon], NOW()) RETURNING id";
  $insert_row = pg_fetch_row(pg_query($db, $query));
  $location_id = $insert_row[0];
  e($query);

  $query = "INSERT INTO assets (asset_type_id, current_location_id, visibility_id, created_at, updated_at)
            VALUES (1, $location_id, 4, NOW(), NOW())
            RETURNING id";
  $insert_row = pg_fetch_row(pg_query($db, $query));
  $asset_id = $insert_row[0];
  e($query);

  $query = "INSERT INTO tethers (asset_id, device_id, created_at, updated_at) VALUES ($asset_id, $device_id, NOW(), NOW())";
  pg_query($db, $query);
  e($query);

  $query = "INSERT INTO ships (asset_id, speed, cog, status, updated_at)
            VALUES ($asset_id, $data[speed], $data[cog], $data[status], NOW())"; 
  pg_query($db, $query);
  e($query);

  return $asset_id;
}

function e($arg) {
  // comment out for no output
  echo($arg . "\n");
}


?>
