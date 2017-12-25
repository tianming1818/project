<?php
error_reporting(0);
header("Content-Type:text/html;charset=utf-8");

//session_start();
if ($_COOKIE['username']){
	echo "user " . $_COOKIE['username'];
}else{
	echo '<a href="login.php">登录</a>';  
	exit;
}


if(!$_FILES["file"]["name"]){
	echo "请选择上传的文件";
	exit(1);
}

if(!$_POST['bookname']){
 	echo "please enter bookname";
 	exit(1);
}
if(!$_POST['renname']){
 	echo "please enter reader name";
 	exit(1);

}
include 'conn.php';

if ((($_FILES["file"]["type"] == "image/jpeg")
|| ($_FILES["file"]["type"] == "image/png")
|| ($_FILES["file"]["type"] == "image/pjpeg"))
&& ($_FILES["file"]["size"] < 2000000))
  {
  if ($_FILES["file"]["error"] > 0)
    {
    echo "Return Code: " . $_FILES["file"]["error"] . "<br />";
    }
  else
    {
    echo "Upload: " . $_FILES["file"]["name"] . "<br />";
    echo "Type: " . $_FILES["file"]["type"] . "<br />";
    echo "Size: " . ($_FILES["file"]["size"] / 1024) . " Kb<br />";
    echo "Temp file: " . $_FILES["file"]["tmp_name"] . "<br />";

    if (file_exists("images/" . $_FILES["file"]["name"]))
      {
      echo $_FILES["file"]["name"] . " already exists. ";
      }
    else
      {
      move_uploaded_file($_FILES["file"]["tmp_name"],
      "images/" . $_FILES["file"]["name"]);
      echo "Stored in: " . "images/" . $_FILES["file"]["name"];
      }
    }
  }
else
  {
  echo "Invalid file";
  }
 
 
 
$image_file = $_FILES["file"]["name"];
$bookname = $_POST['bookname'];
$renname = $_POST['renname'];




$sql= "INSERT INTO book (name,bookname,bookimage) VALUES ('$renname','$bookname','$image_file');";
   $ret = $db->exec($sql);
   if(!$ret){
      echo $db->lastErrorMsg();
   } else {
      echo "Insert data successfully\n";
   }


//添加成功跳转回首页
$page="service.php";
echo "<script>alert('添加成功');window.location = \"".$page."\";</script>";

?>
