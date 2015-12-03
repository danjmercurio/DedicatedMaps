<?php
/***************************************************************************

Copyright (C) Dedicated Maps
www.dedicatedmaps.com
Author:	Dave Miller (based on version 0.0 by Mike Turner)

File Name: parse_feed_staging.php
Location: /public/ais
Description: 

This is the continuous feed from the AIS system. It populates the railsais
database with ais 1 and ais 5 data. Every five minutes that data gets moved
over into the rails database where it is available for maps. Note that there 
are unique indices on the mmsi fields in both tables. This means we don't keep 
*all* of the AIS history for a ship; only the 5 minute snapshots that these
tables contain.

Changelog:

v1.0.0	09-06-09
	Initial version of file
	
v1.0.1  09-16-09
	Script had trouble maintaining persistant db connection. So we now store
	the data in memory and re-connect to the database every thirty seconds.
	Note also that we store the data in an associative array with the MMSI 
	as the key. This means we don't keep the complete AIS history, but rather
	insert only the last value.
  
v1.0.2 01-19-10
  Created this version that feeds the staging database "stagingais" rather than 
  "railsais"

*****************************************************************************/

// If this script is already running, exit.
preg_match_all('|' . preg_quote(__FILE__) . '|', `ps gx`, $matches);
if (count($matches[0]) > 1) {
  echo('Already running. Exiting...');
  exit();
}

// run FOREVER?
ignore_user_abort(true);
set_time_limit(0);

// location of feed
$sock = fsockopen('216.177.253.143', 3131, $errno, $errstr, 15);
//$sock = fsockopen('206.72.107.155', 1000, $errno, $errstr, 15);

// location of parser
$parserLocation = "/home2/dedicat5/bin/ais_ddm";
$descriptorspec = array(
  0 => array("pipe", "r"),  // stdin is a pipe that the child will read from
  1 => array("pipe", "w"),  // stdout is a pipe that the child will write to
  2 => array("file","aiserror.log", "w") // stderr is a file to write to
);

// database object
include_once('../../../ddmaps/public/utils/db.php');
include_once('../../../ddmaps/public/utils/utils.php');

// Start feed/parse/update loop
if (!$sock) {
  die($_err.$errstr.$errno);
} else {
  echo "Connected to ais server<hr />";

  $ais1 = array();
  $ais5 = array();
  $timer = time();
  $hour_reset = 0;
  while (!feof($sock)) {
    $line = fgets($sock);
    pr($line);
    $process = proc_open($parserLocation, $descriptorspec, $pipes);
    if (is_resource($process)) {
      fwrite($pipes[0],$line."\n");
      // check for AIS 5 packet
      if (substr_count($line,"!AIVDM,2,1,3") > 0) {
       	$line2 = fgets($sock);     
	fwrite($pipes[0],$line2."\n");
      }
      fclose($pipes[0]);
      // get AIS results
      while (!feof($pipes[1])) {
        $out = fgets($pipes[1]);
        $data = explode(",",$out);
        //pr($data);
        if ($data[0] == 1) $ais1[ $data[1] ] = $data;	
        if ($data[0] == 5) $ais5[ $data[1] ] = $data;
      } // end while       
    } else {
      Debug::getInstance()->debugMsg('AIS parser stopped: ' . date("D M j G:i:s T Y"));
      break; // parser stopped. Exit and let cron fire thing back up within 5 min.
    } // end if
    fclose($pipes[1]);
    proc_close($process);
    
    if ((time() - $timer) > 30) { // write the data every thirty seconds
      $db = Db::getInstance('dedicat5_stagingais');
      foreach($ais1 as $entry) {
        insert_ais1($db, $entry);
      } 
      foreach($ais5 as $entry) {
        insert_ais5($db, $entry);
      }
     $hour_reset++;
     $db = 0;
     $ais1 = array();
     $ais5 = array();
     $timer = time();
     if ($hour_reset > 118) {
     	fclose($sock);
     	Debug::getInstance()->debugMsg('Hourly reset: ' . date("D M j G:i:s T Y"));
     	exit();
     	// Turn off the feed and let cron restart it in 30 seconds
     }
     //echo("dumping...<hr />");
     }
  } // end while
  //echo("closing");
  Debug::getInstance()->debugMsg('AIS feed socket closed: ' . date("D M j G:i:s T Y"));
  fclose($sock);
} // end if
echo("done.");

function insert_ais1($db, $data) {

   $data = array_map('mysql_real_escape_string', $data);

   $mmsi = $data[1];
   $lat = $data[2];
   $lon = $data[3];
   $cog = $data[4] / 10;
   $speed = $data[5] / 10;
   $status = $data[6];
   
   $query = "INSERT ais_1 (mmsi, lat, lon, cog, speed, status, timestamp)
             VALUES ($mmsi, $lat, $lon, $cog, $speed, $status, NOW())
             ON DUPLICATE KEY UPDATE
             lat = $lat,
             lon = $lon,
             cog = $cog,
             speed = $speed,
             status = $status,
             timestamp = NOW()
             ";
   $db->query($query, false);               
   //pr($query);
}

function insert_ais5($db, $data) {
   // If destination has a comma, correct comma separated list
   
   if (count($data) > 12) {
     $data = fix_commas($data);
   }
   
   $data = array_map('mysql_real_escape_string', $data);
   
   $mmsi = $data[1];
   $name = trim(str_replace("@","",$data[2]));
   $type = $data[3];
   $bow = $data[4];
   $stern = $data[5];
   $port = $data[6];
   $starboard = $data[7];
   $draught = $data[8];
   $destination = trim(str_replace("@","",$data[9]));
   $eta = $data[10];
              
   $query = "INSERT ais_5 (mmsi, name, type, dim_bow, dim_stern,
             dim_port, dim_starboard, draught, destination, eta, timestamp)
             VALUES ($mmsi,'$name',$type,$bow,$stern,$port,
             $starboard,$draught,'$destination',DATE('1970-12-31 01:00:00'),NOW())
             ON DUPLICATE KEY UPDATE
             destination = '$destination',
             eta = DATE('1970-12-31 01:00:00'),
             timestamp = NOW()";

   $db->query($query, false);
   //pr($query);
}

function fix_commas($data) {
// Check for commas in the two string fields: slots 2 and 9
//367241000,'R',V_ATLANTIS,60,20,63,5,11,'56,SANFRAN',CA,000610752

  for($i=count($data)-1; $i > 1; $i--) {
    if (!is_numeric($data[$i]) && !is_numeric($data[$i-1])) {
     $data[$i-1] .= ',' . $data[$i];
     array_splice($data, $i,1);
    }
  }
  return $data;
}

// For debugging
function pr($in) {
  echo('<pre>' . print_r($in, true) . '</pre>');
}
?>