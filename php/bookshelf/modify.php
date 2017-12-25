<?php
error_reporting(0);
header("Content-Type:text/html;charset=utf-8");

if(!$_POST['bookname']){
        echo "please enter book number";
        exit(1);

}
if(!$_POST['name']){
        echo "please enter reader name";
        exit(1);

}

include 'conn.php';


if ($_COOKIE['username']){
	echo "user " . $_COOKIE['username'];
}else{
	echo '<a href="login.php">登录</a>';  
	exit;
}

$sql = "UPDATE book set name = '" . $_POST['name'] . "' WHERE id =" . $_POST['bookname'];
echo "<br>$sql<br>";
$ret = $db->exec($sql);
$db->changes();



$sql = "select * from book";
$results = $db->query($sql);
while ($row = $results->fetchArray()){
	var_dump($row);
}

//修改成功跳转回首页
$page="service.php";
echo "<script>alert('修改成功');window.location = \"".$page."\";</script>";


?>
