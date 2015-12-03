<?php
/***************************************************************************

Copyright (C) Dedicated Maps
www.dedicatedmaps.com
Author:	Dave Miller

File Name: send_to_rails.php
Location: /public/ais
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
  
v1.0.2 01-19-10 Dave Miller
  Created this version that feeds the staging database "stagingais" rather than 
  "railsais"  

*****************************************************************************/
// If this script is already running, exit.
preg_match_all('|' . preg_quote(__FILE__) . '|', `ps gx`, $matches);
if (count($matches[0]) > 1) {
  echo('Already running. Exiting...');
  exit();
}

echo 'Starting...<hr />';

// connect to dbs
include_once('../../../ddmaps/public/utils/multi_db.php');
$ais = new database('dedicat5_stagingais');
$rails = new database('dedicat5_staging', true);

// AIS 1
/*
$mmsi = $data[1];
$lat = $data[2];
$lon = $data[3];
$cog = $data[4] ;
$speed = $data[5];
$status = $data[6];
*/
$query = "SELECT * FROM ais_1";
$result = $ais->query($query);
$records_to_delete = array();
while ($data = mysql_fetch_array($result,MYSQL_NUM)) {
  $data = array_map('mysql_real_escape_string', $data);
  if (is_new_ship($rails, $data[1])) {
    $asset_id = init_ship($rails, $data);
  } else {
    $asset_id = get_ship($rails, $data);
    if (!$asset_id) continue; //Case where user creates AIS device but doesn't tether to a ship.
    if ((is_tagged_or_dedicated($rails, $asset_id)) && (!is_at_port($data))) {
      record_history($rails, $asset_id);
    }
  }
  //e("update location: asset.id => $asset_id");
  update_ship_location($rails, $asset_id, $data);
  $records_to_delete[] = $data[0];
}
remove_stale_ships($rails);

// Remove processed records from ais_1
if (count($records_to_delete) > 0) {
  $query = 'DELETE FROM ais_1 WHERE id IN (' . implode(',', $records_to_delete) . ')';
  $ais->query($query);
}

echo 'Completed AIS 1<hr />';

//AIS 5
/*
$mmsi = $data[1];
$name = $data[2]);
$type = $data[3];
$bow = $data[4];
$stern = $data[5];
$port = $data[6];
$starboard = $data[7];
$draught = $data[8];
$destination = $data[9]);
$eta = $data[10];
*/
$query = "SELECT * FROM ais_5";
$result = $ais->query($query);
$records_to_delete = array();
while ($data = mysql_fetch_array($result,MYSQL_NUM)) {
  $data = array_map('mysql_real_escape_string', $data);
  if (!is_new_ship($rails, $data[1])) {
    $asset_id = get_ship($rails, $data);
    record_ship_specs($rails, $asset_id, $data);
  }
  $records_to_delete[] = $data[0];
}
// Remove processed records from ais_5
if (count($records_to_delete) > 0) {
  $query = 'DELETE FROM ais_5 WHERE id IN (' . implode(',', $records_to_delete) . ')';
  $ais->query($query);
}

echo 'Completed AIS 5<hr />';

echo ('Rails updated.');

function remove_stale_ships($db) {
  // If a ship is public, not at port, not tagged, and hasn't updated in 24 hours, remove it from the database.
  $query = "DELETE FROM ships, assets, current_locations, tethers, devices
                USING ships 
                INNER JOIN assets ON (assets.id = ships.asset_id) 
                INNER JOIN current_locations ON (assets.current_location_id = current_locations.id) 
                INNER JOIN tethers ON (assets.id = tethers.asset_id)
                INNER JOIN devices ON (current_locations.device_id = devices.id)
                LEFT OUTER JOIN tags ON (assets.id = tags.asset_id)
                WHERE current_locations.timestamp< DATE_SUB(NOW(),INTERVAL 1 HOUR)
                AND ships.at_port = 0
                AND assets.client_id is null
                AND tags.user_id is null
                ";
  $result = $db->query($query);
}

function record_ship_specs($db, $in_asset_id, $in_data) {
  $query = "UPDATE ships, ais_ship_type_icons SET
                ships.icon_id = ais_ship_type_icons.icon_id,
                dim_bow = $in_data[4],
                dim_stern = $in_data[5],
                dim_port = $in_data[6],
                dim_starboard = $in_data[7],
                draught =  $in_data[8],
                destination = '$in_data[9]',
                eta = $in_data[10],
                updated_at = NOW()
                WHERE asset_id = $in_asset_id
                AND ais_ship_type_icons.ship_type_code = $in_data[3];";
  $db->query($query);
  //e($query);

  $query = "UPDATE assets SET common_name = '$in_data[2]' WHERE id = $in_asset_id;";
  $db->query($query);
  //e($query);
}
  
function is_at_port($in_data) {
  if ($in_data[5] < 0.2) { // less than 2 m/s
    return(1);
  } else {
    return(0);
  }
}

function record_history($db, $in_asset_id) {
  $query = "INSERT INTO past_locations (asset_id, lat, lon, timestamp)
                  SELECT $in_asset_id, current_locations.lat, current_locations.lon, current_locations.timestamp
                    FROM current_locations, assets
                      WHERE assets.id = $in_asset_id
                      AND current_locations.id = assets.current_location_id";
  $db->query($query);
  //e($query);
}

function is_tagged_or_dedicated($db, $in_asset_id) {
  $query = "SELECT COUNT(*) FROM tags WHERE asset_id = $in_asset_id LIMIT 1";
  $result = mysql_fetch_array($db->query($query));
  if ($result[0] > 0) return true;
  
  $query = "SELECT COUNT(*) FROM assets WHERE id = $in_asset_id AND client_id != null";
  $result = mysql_fetch_array($db->query($query));
  if ($result[0] > 0) return true;
  
  return false;
}

function update_ship_location($db, $in_asset_id, $in_data) {
  $query= "UPDATE current_locations, assets SET 
                current_locations.lat = $in_data[2],
                current_locations.lon = $in_data[3],
                current_locations.timestamp = NOW()
                WHERE assets.id = $in_asset_id
                AND current_locations.id = assets.current_location_id";
                
  $db->query($query);

  // If ship is already at port, don't update its cog
  $query ="SELECT at_port, cog FROM ships WHERE asset_id = $in_asset_id";
  $result = mysql_fetch_array($db->query($query));
  if ($result['at_port']) {
    $cog = $result['cog'];
  } else {
    $cog = $in_data[4];
  } 
  
  $speed = $in_data[5];

  $is_at_port = is_at_port($in_data);

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
 
  $status = $ais_status[$in_data[6]];

  $query = "UPDATE ships SET 
                  at_port = $is_at_port,
                  cog = $cog,
                  speed = $speed,
                  status = '$status',
                  updated_at = NOW()
                WHERE asset_id = $in_asset_id";
  $db->query($query);
  //e($query);
}

function get_ship($db, $in_data) {
  $query = "SELECT assets.id FROM assets
                  JOIN tethers ON (assets.id = tethers.asset_id)
                  JOIN devices ON (tethers.device_id = devices.id)
                  WHERE devices.serial_number = $in_data[1]";
  //e($query);
  $result = mysql_fetch_array($db->query($query));
  if (!$result) $result['id'] = 0;
  return $result['id'];
}

function is_new_ship($db, $mmsi) {
  $query = "SELECT id FROM devices WHERE serial_number = '$mmsi'";
  return($db->numResults($query) == 0);
}

function init_ship($db, $in_data) {
  $query = "INSERT devices SET serial_number = '$in_data[1]', device_type_id = 1";
  $db->query($query);
  $device_id = mysql_insert_id($db->link);

  $query = "INSERT current_locations SET
                          device_id = $device_id,
                          lat = $in_data[2],
                          lon = $in_data[3],
                          timestamp= NOW()";
  $db->query($query);
  $location_id = mysql_insert_id($db->link);

  $query = "INSERT assets SET
                          asset_type_id = 1,
                          current_location_id = $location_id,
                          visibility_id = 4,
                          created_at = NOW(),
                          updated_at = NOW()";
  $db->query($query);
  $asset_id = mysql_insert_id($db->link);

  $query = "INSERT tethers SET
                          asset_id = $asset_id,
                          device_id = $device_id,
                          created_at = NOW(),
                          updated_at = NOW()";
  $db->query($query);

  $query = "INSERT ships SET
                          asset_id = $asset_id,
                          speed = $in_data[5],
                          cog = $in_data[4],
                          status = $in_data[6],
                          updated_at = NOW()";
  $db->query($query);

  return $asset_id;
}

function e($arg) {
  echo($arg . '<br /><br />');
}


?>