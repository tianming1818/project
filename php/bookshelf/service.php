<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>图书借阅</title>
	<style>
	#aa{
		background:cover;
	}
	body {
		background-image: url(images/background.jpg);
}
	</style>

</head>
<body>
<h1 align=center>SERVER组图书借阅系统</h1>




<?php
error_reporting(0);
header("Content-Type:text/html;charset=utf-8");
include('conn.php');
//以下3行代码注销后禁止回退
header("Cache-control:no-cache,no-store,must-revalidate");
header("Pragma:no-cache");
header("Expires:0");



if ($_COOKIE['username']){
	echo $_COOKIE['username'] . ' 欢迎您！'; 
	echo '点击此处 <a href="login.php?action=logout">注销</a> 登录！<br />';
}else{
	echo '点击此处 <a href="login.php?action=logout">登录</a>'; 
}




//显示书籍列表
$sql = "select * from book";
$results = $db->query($sql);
echo "<table  border=1><tr>";
while ($row = $results->fetchArray()){
 echo "<td align=center><h4>$row[0]</h4></td>";
}
echo "</tr><tr>";
while ($row = $results->fetchArray()){
 echo "<td align=center><h4>$row[2]</h4></td>";
}
echo "</tr><tr>";
while ($row = $results->fetchArray()){
 echo "<td align=center><img height=600 width=100 src=images/$row[3]></td>";
  }
echo "</tr><tr>";
while ($row = $results->fetchArray()){
 echo "<td align=center><h4>$row[1]</h4></td>";
}
echo "</tr></table>";


if ($_COOKIE['username']){
	echo "welcome to " . $_COOKIE['username'];
}else{
	echo '<a href="login.php">登录</a>';  
	setcookie('PHPSESSID');
	exit;
}


if($_GET['action'] == "logout"){  
    //unset($_SESSION['username']);  
    //session_destroy();
    setcookie('PHPSESSID');
    setcookie('username');
    echo '注销登录成功！点击此处 <a href="login.php?action=logout">登录</a>';  
    exit;  
}  




echo "<h2>新增：</h2>";
echo "<form action='upload_file.php' method='post' enctype='multipart/form-data'>";
echo "<label for='file'>Filename:</label>";
echo "<input type='file' name='file' id='file' /> ";
echo "<br />";
echo "书&nbsp;&nbsp;名：<input type='text' name='bookname'>";
echo "借阅人：<input type='text' name='renname'>";
echo "<input type='submit' name='submit' value='Submit' />";
echo "</form>";
echo "<h2>修改：</h2>";
echo "<form action='modify.php' method='post' >";
echo "书籍编号：<input type='text' name='bookname'>";
echo "借阅人：<input type='text' name='name'>";
echo "<input type='submit' name='submit' value='Submit' />";
echo "</form>";
echo "<h2>删除书籍：</h2>";
echo "<form action='delete.php' method='post' >";
echo "书籍编号：<input type='text' name='bookname'>";
echo "<input type='submit' name='submit' value='Submit' />";
echo "</form>";

?>

<!-- 以下代码注销后禁止回退 -->
<SCRIPT language="JavaScript">
javascript:window.history.forward(1);
</SCRIPT>

</body>
</html>
