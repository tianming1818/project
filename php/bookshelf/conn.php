<?php
	
 class MyDB extends SQLite3
 {
    function __construct()
    {
       $this->open('service.db');
    }
 }
 $db = new MyDB();
 
 $username = 'root';
 //password: 123
 $password = '202cb962ac59075b964b07152d234b70';
 ?>