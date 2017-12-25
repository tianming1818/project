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


setcookie('username');
error_reporting(0);
header("Content-Type:text/html;charset=utf-8");//$str = file_get_contents("service.txt");
echo "<form name='LoginForm' method='post' action='login_success.php' onSubmit='return InputCheck(this)'> ";
echo "<p>";
echo "<label for='username' class='label'>用户名:</label>";
echo "<input id='username' name='username' type='text' class='input' />";
echo "<p/> ";
echo "<p> ";
echo "<label for='password' class='label'>密&nbsp;码:</label>";
echo "<input id='password' name='password' type='password' class='input' />";
echo "<p/>";
echo "<p>";
echo "<input type='submit' name='submit' value='提交' class='left' />";
echo "</p>";
echo "</form>";


?>

</body>