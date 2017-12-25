<?php
error_reporting(0);
header("Content-Type:text/html;charset=utf-8");

if(!$_POST['bookname']){
 	echo "please enter bookname";
 	exit(1);
}
include 'conn.php';


if ($_COOKIE['username']){
	echo "user " . $_COOKIE['username'];
}else{
	echo '<a href="login.php">登陆</a>';  
	exit;
}


$bookname = $_POST['bookname'];
$sql = "delete from book where id = '$bookname'";
$ret = $db->exec($sql);
if(!$ret){
    echo $db->lastErrorMsg();
} else {
   echo "delete data successfully\n";
}

//删除成功跳转回首页
$page="service.php";
echo "<script>alert('删除成功');window.location = \"".$page."\";</script>"; 
	
	
?>