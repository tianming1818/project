<?php
error_reporting(0);



//获取上传的用户名密码验证登陆
$user = htmlspecialchars($_POST['username']);  
$pass = MD5($_POST['password']);  

//$username和$password从conn.php中获取;
include('conn.php');
if($user == $username and $pass == $password){
	//session_start();  
    //$_SESSION['username'] = $_POST['username'];  
    //$_SESSION['userid'] = $result['userid'];  
    //echo $_SESSION['username'] . ' 欢迎您！';  
    setcookie('username',$_POST['username'],time()+60*60);
    echo $_COOKIE['username'] . '欢迎您！';  
	echo '点击此处 <a href="service.php?action=logout">注销</a> 登录！<br />';   
}else {  
    exit('登录失败！点击此处 <a href="login.php?action=logout">返回</a> 重试');  
}  



if($_POST['action'] == "logout"){  
    //unset($_SESSION['userid']);  
    //unset($_SESSION['username']);  
    setcookie('PHPSESSID');
    echo '注销登录成功！点击此处 <a href="service.php?action=logout">登录</a>';  
    exit;  
}  
$page="service.php";
echo "<script>alert('登陆成功');window.location = \"".$page."\";</script>";

?>