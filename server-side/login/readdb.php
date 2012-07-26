<?php

include"login_config.php";
include_once("../JSON.php");
$json = new Services_JSON();
   mysql_connect( $db_host, $db_username, $db_password )
      or die( "Error! Could not connect to database: " . mysql_error() );
   
   // select the database
   mysql_select_db( $db )
      or die( "Error! Could not select the database: " . mysql_error() );

$query = "SELECT * FROM users";
$result = mysql_query($query);
$arr = array();
$rs = mysql_query("SELECT * FROM users");
while($obj = mysql_fetch_object($rs)) {
 $arr[] = $obj;
}
Echo $json->encode($arr);
?>
