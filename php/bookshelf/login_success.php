<?php
error_reporting(0);



//��ȡ�ϴ����û���������֤��½
$user = htmlspecialchars($_POST['username']);  
$pass = MD5($_POST['password']);  

//$username��$password��conn.php�л�ȡ;
include('conn.php');
if($user == $username and $pass == $password){
	//session_start();  
    //$_SESSION['username'] = $_POST['username'];  
    //$_SESSION['userid'] = $result['userid'];  
    //echo $_SESSION['username'] . ' ��ӭ����';  
    setcookie('username',$_POST['username'],time()+60*60);
    echo $_COOKIE['username'] . '��ӭ����';  
	echo '����˴� <a href="service.php?action=logout">ע��</a> ��¼��<br />';   
}else {  
    exit('��¼ʧ�ܣ�����˴� <a href="login.php?action=logout">����</a> ����');  
}  



if($_POST['action'] == "logout"){  
    //unset($_SESSION['userid']);  
    //unset($_SESSION['username']);  
    setcookie('PHPSESSID');
    echo 'ע����¼�ɹ�������˴� <a href="service.php?action=logout">��¼</a>';  
    exit;  
}  
$page="service.php";
echo "<script>alert('��½�ɹ�');window.location = \"".$page."\";</script>";

?>