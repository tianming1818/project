<?php
include("config.php");
$sinfo = "$mysqlHost:$mysqlPort:/var/lib/mysql/mysql.sock";
$user = "root";
$passwd = "tingyun2o13";
$dbname = "test";
$sql = "select * from users";

$link = mysql_connect($sinfo, $user, $passwd);
mysql_select_db($dbname);
$result = mysql_query($sql, $link);
print_r(mysql_fetch_row($result));
mysql_close($link);

?>
