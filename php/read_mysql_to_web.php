<?php
//创建数据库连接
$mysqli = mysqli_connect("192.168.2.140", "root", "nbs2o13", "user_sign");
if ($mysqli->connect_errno) {
    printf("Connect failed: %s\n", $mysqli->connect_error);
    exit();
}

//function_exists($mysqli->query());
//echo "<br>";
//获取列的字段
function getlistname($mysqli){
	$list="select COLUMN_NAME from information_schema.COLUMNS where table_name ='retu'";
	$list_resu=$mysqli->query($list);
	if ($list_resu){
	        if($list_resu->num_rows>0){
				$arrlist=array();
			while($list2=$list_resu->fetch_assoc()){
				$arrlist[]=$list2['COLUMN_NAME'];
				
				}
	
			}
		}
	return $arrlist;
}

//将列的各字段存储在一个数组中 $arrlist
function getrow($mysqli){
//获取各行的数据
	$sql="select * from retu";
	$result=$mysqli->query($sql);
	if ($result){
		if($result->num_rows>0){
				$arrall=array();
			//将行的结果返回到数组$row中
			while($row =$result->fetch_all()){
	//			echo "<br>";
				//根据列的字段数量来获取每行共多少个字段,再将每一行的数据读取放入一个二维数组$arrall中
				//for ($a=0;$a<count($arrlist);$a++){
				for ($a=0;$a<count($row);$a++){
					$arrall[]=$row[$a];
				}
			}
		}
	}else {
	         echo "select from database failed";
	}
		$result->free();
		$mysqli->close();
		return $arrall;
}


//print_r($arrall);
//echo "<br>";
//开始输出第一行属性
function outtable($arrlist,$arrall){
	echo "<table border=4 align=center bgcolor=#ccccff>";
	echo "<tr>";
	for ($a=0;$a<count($arrlist);$a++){
		echo "<td>$arrlist[$a]";
	}
	
	//开始输出所有行的数据,遍历二维数组
	for ($x=0;$x<count($arrall);$x++){
		echo "<tr>";
		for ($y=0;$y<count($arrlist);$y++){
		  echo "<td>";
		  echo $arrall[$x][$y];
		  echo "</td>";
		
		}
	
	}
	echo "</table>";
}

$arrlist=getlistname($mysqli);
$arrall=getrow($mysqli);
outtable($arrlist,$arrall);

?>
