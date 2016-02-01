<?php

//ini_set('display_errors', 0);
header("Expires: Mon, 26 Jul 1997 05:00:00 GMT" );
header("Last-Modified: " . gmdate( "D, d M Y H:i:s" ) . "GMT" );
header("Cache-Control: no-cache, must-revalidate" );
header("Pragma: no-cache" );
header("Content-type: application/json");
echo json_encode(getDirectory('.'));

function getDirectory( $path = '.' ){

    $ret_array = array();

    $ignore = array( 'images.php', 'json.php', 'ships', 'cgi-bin', '.', '..' );

    $dh = @opendir( $path );
    while( false !== ( $file = readdir( $dh ) ) ){
        if( !in_array( $file, $ignore ) ){
            if( is_dir( "$path/$file" ) ){
                $ret_array[] = getDirectory( "$path/$file" );
            } else {
                if ( !in_array( $file, $ignore ) && substr($file, -10) != 'shadow.png') {
                   $ret_array[] = "'" . substr($file, 0, -4) . "'";
                }
            }
        }
    }
    closedir( $dh );
    if ($path == '.') $path = 'images';
    //return '{' . end(split('/',$path)) . ':' . '[' . join(',',$ret_array) . ']}';
    return array( end(split('/',$path)) => $ret_array );
} 


?>

