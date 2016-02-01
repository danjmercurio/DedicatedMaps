<?php

$files = getDirectory('.');
echo "<table><tr height='90'>";
$n = 0;
foreach($files as $file) {
    $n++;
    echo "<td><img src='/" . $file  . ".png'/><br />$file</td>";
    if ($n % 4 == 0) echo "</tr><tr height='90'>";
}
echo '</tr></table>';

function getDirectory( $path = '.' ){

    $ret_array = array();

    $ignore = array('images.php', 'json.php', 'ships', 'cgi-bin', '.', '..' );

    $dh = @opendir( $path );
    while( false !== ( $file = readdir( $dh ) ) ){
        if( !in_array( $file, $ignore ) ){
            if( is_dir( "$path/$file" ) ){
                $ret_array = array_merge($ret_array, getDirectory( "$path/$file" ));
            
            } else {
                if ( !in_array( $file, $ignore ) && substr($file, -10) != 'shadow.png') {
                  $ret_array[] = substr("$path/$file",2,-4);
                }
            }
        }
    }
    closedir( $dh );
    natsort($ret_array);
    return $ret_array;
}

?>
