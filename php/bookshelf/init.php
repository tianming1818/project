<?php
	
 class MyDB extends SQLite3
 {
    function __construct()
    {
       $this->open('service.db');
    }
 }
 $db = new MyDB();

 if(!$db){
    echo $db->lastErrorMsg();
 } else {
    echo "Opened database successfully\n";
 }	

echo "<br>";

echo "################## create table #######################";
echo "<br>";
$sql="CREATE TABLE book(ID INTEGER PRIMARY KEY   AUTOINCREMENT, name varchar(10)  NOT NULL, bookname varchar(30) not null,bookimage varchar(20) not null );";
   $ret = $db->exec($sql);
   if(!$ret){
      echo $db->lastErrorMsg();
   } else {
      echo "table create successfully\n";
   }





?>