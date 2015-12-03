<?php

/***************************************************************************

Copyright (C) Dedicated Maps
www.dedicatedmaps.com
Author:  Leif Warner

File Name: parse.php
Location: /data
Description: 
Loads Access tables uploaded in XML form into database.

Changelog:

v1.0.0  7-13-09
  Initial version of file.

09-01-09 - Dave Miller
  Changed table names to be Rails friendly
  
12-02-09 - Dave Miller
  Removed functionality for processing fishing area and grp data.
  Added functionality for processing staging areas one company at a time.
  Also created new XSL transformations for staging areas.
******************************************************************************/
$db = new mysqli("localhost", "dedicat5_rescuee", "reDbasKet", "dedicat5_staging");
if (mysqli_connect_errno()) {
  printf("Connect failed: %s\n", mysqli_connect_error());
  exit();
}

$debugXML = 0;
$debugDB = 0;
if (isset($_GET['mode'])) {
  if ($_GET['mode'] == 'debug') $debugXML = 1;
  if ($_GET['mode'] == 'debugDB') $debugDB = 1;
}

if ($debugDB) mysqli_report(MYSQLI_REPORT_ERROR);

// File names for XML and XSL files, and corresponding tables, detail tables, and foreign keys.
$files = array(
  "Map_Asset_Types" => array("staging_area_asset_types", "", ""),
  "Map_Locations" => array("staging_areas", "staging_area_details", "staging_area_id"),
  "Map_Assets" => array("staging_area_assets", "staging_area_asset_details", "staging_area_asset_id"));

/*** NOTE those client ids are hard coded in Map_Locations.XSL too ***/
$client_ids = array(
	'CRC' => 1,
	'MFSA' => 2,
	'POI' => 3,
	'MSRC' => 4,
	'NRC' => 5,
	'BCO' => 6,

);

// Make sure client directory, XML, and XSL files exist
if (!isset($_GET['client'])) err("Client param required.");
$client = strtoupper($_GET['client']);
if (!is_dir($client)) err("Client directory not found.");

// POIs have no assets or asset_typs
if ($client == "POI") {
  unset($files['Map_Assets']);
  unset($files['Map_Asset_Types']);	
}
//Keep track of access_ids so we can maintain foreign keys
$ids = array();

// Delete old records for this client (our odd schema requires three queries)
$client_id = $client_ids[strtoupper($client)];

$query = "DELETE FROM staging_areas, staging_area_details
USING staging_areas
LEFT OUTER JOIN staging_area_details ON (staging_areas.id = staging_area_details.staging_area_id)
WHERE staging_areas.staging_area_company_id = $client_id";
$db->query($query);
if ($debugDB) pr($query);

$query = "DELETE FROM staging_area_assets, staging_area_asset_details
USING staging_area_assets
LEFT OUTER JOIN staging_area_asset_details ON (staging_area_assets.id = staging_area_asset_details.staging_area_asset_id)
WHERE staging_area_asset_type_id IN
(SELECT id FROM staging_area_asset_types WHERE staging_area_asset_types.staging_area_company_id = $client_id)";
$db->query($query);
if ($debugDB) pr($query);

$query = "DELETE FROM staging_area_asset_types
WHERE staging_area_asset_types.staging_area_company_id = $client_id";
$db->query($query);
if ($debugDB) pr($query);

foreach ($files as $file => $table) {
  $xml_file = "/home/sftp/staging_areas/" . $client . "/" . $file . ".xml";
  $xsl_file = $file . ".xsl";
  if (!file_exists($xml_file)) err("$xml_file not found.");
  if (!file_exists($xsl_file)) err("$xsl_file not found.");

  // Apply the XSL transformations and insert the data
  if ($debugXML) echo "<hr />Attempting $file => $table[0]<br /><br />\n"; // debugging / progress output
  $xsl = new DOMDocument();
  $xsl->load($xsl_file);
  $proc = new XSLTProcessor();
  $proc->importStyleSheet($xsl);
  $xml = new DOMDocument();
  $xml->load($xml_file);
  if ($proc) $xml = $proc->transformToDoc($xml);
  if ($debugXML) echo('<pre>' . htmlentities($xml->saveXML()) . '</pre>'); // debugging / progress output
  if ($file != 'Map_Assets') {
    $ids["$table[0]"] = insertXML($db, $table[0], $table[1], $table[2], $xml, $debugDB);
  } else {
	 // $ids needs to be built by this point, so make sure $files are in the right order ("Map_Assets" last)
    $xml = addForeignKeys($xml, $ids);
    insertXML($db, $table[0], $table[1], $table[2], $xml, $debugDB);
  }
  if ($debugXML) echo "$file Updated => $table[0]<br />\n"; // debugging / progress output 
}

$db->close();
if (!($debugXML || $debugDB)) header("Location: /public/success");
exit();



// Add the staging_area_id and staging_area_aset_type_id cols and vals to 
// the staging_area_assets xml so they'll join properly.
function addForeignKeys($xml, $ids) {
  $records = $xml->documentElement->childNodes;
  foreach ($records as $record) {
    if ($record->nodeType == XML_ELEMENT_NODE) {
      $columns = $record->childNodes;
      foreach ($columns as $column) {
        if ($column->nodeName == 'staging_area_id') $column->nodeValue = $ids['staging_areas'][$column->nodeValue];
        if ($column->nodeName == 'staging_area_asset_type_id') $column->nodeValue = $ids['staging_area_asset_types'][$column->nodeValue];
      }
    }
  }
  return $xml;
}

// Do the table inserts and return an assoc array with keys = access_id and vals = insert id.
function insertXML($db, $table, $details_table, $foreign_key, $xml, $debugDB) {
  $records = $xml->documentElement->childNodes;
  $ids = array();
  $n = 0;
  foreach ($records as $record) {
    $fields = array();
    $details = array();
    if ($record->nodeType == XML_ELEMENT_NODE) {
      $columns = $record->childNodes;
      foreach ($columns as $column) {
        if ($column->nodeType == XML_ELEMENT_NODE) {
          // Details nodes have children so handle them separately
          if ($column->firstChild->nodeType == XML_ELEMENT_NODE) {
            $details[] = array(addslashes($column->firstChild->nodeName), addslashes($column->firstChild->nodeValue));
          } else {
            // Don't insert the access_id, just record it.
            if ($column->nodeName == 'access_id') {
              $access_id = $column->nodeValue;
            } else {
              $fields[strtolower($column->nodeName)] = addslashes($column->nodeValue);  
            }
          }
        }
      }
      // Insert the record
      $n++;
      $query = "INSERT INTO ". $table ." (". implode(", ", array_map("strtolower", array_keys($fields)) ) . ") VALUES ". parenthesize($fields);
      $db->query($query);
      $insert_id = $db->insert_id;
      // $insert_id = 999;
      if ($debugDB) echo $query . "<br />";
      $ids[$access_id] = $insert_id;
      // Insert the details
      if (!empty($details)) {
        foreach ($details as $detail) {
          array_unshift($detail, $insert_id);
          $query = "INSERT INTO ". $details_table ." ($foreign_key,name,value) VALUES ". parenthesize($detail);
			 $db->query($query);
          if ($debugDB) echo $query . "<br />";
        }
      }
      if ($debugDB) echo ("<hr/>");
    }
  }
  if ($debugDB) echo $table . ' ' . $n . "<hr/>";
  return $ids;
}

// parenthesize(array(var1,var2,...varn))
// returns the string "('val1', 'val2', 'valn')", a comma-separated string of quoted array values.
// Used to generate SQL insert statements.
function parenthesize($array) {
  return "('" . implode("', '", $array) . "')";
}

// For debugging in the browser
function pr($arg) {
  echo '<pre>';
  print_r($arg);
  echo '</pre>';
}

function err($msg) {
  die($msg);
}

?>
