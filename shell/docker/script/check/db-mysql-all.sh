#!/bin/bash
file=$2
count=$1
if  grep 'SIGSEGV' /var/log/networkbench/php-agent.log > /dev/null 2>&1;then
	check="${check}, SIGSEGV Exists"
else
	echo "no SIGSEGV passed"
	if [ $count -eq 3 ]
	then
		echo "<tr class='success'><td>$file验证</td><td>no SIGSEGV验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>no SIGSEGV验证成功</td></tr>" >>/docker/log/index.html
	fi
fi


if grep 'db=MySQL' /var/log/networkbench/php-agent.log > /dev/null 2>&1;then
	echo -e "db=MySQL passed"
	if [ $count -eq 3 ];then
	echo "<tr class='success'><td>$file验证</td><td> db=MySQL验证</td><td>成功</td><td style='width:100%；word-wrap:break-word;'>db=MySQL验证成功</td></tr>" >>/docker/log/index.html            
fi
else
check="${check}, no db=MySQL"
fi

if grep 'dbhost=192.168.2.129' /var/log/networkbench/php-agent.log > /dev/null 2>&1;then
	echo -e "dbhost=192.168.2.129"
	if [ $count -eq 3 ];then
	echo "<tr class='success'><td>$file验证</td><td> dbhost=192.168.2.129验证</td><td>成功</td><td style='width:100%；word-wrap:break-word;'>dbhost=192.168.2.129验证成功</td></tr>" >>/docker/log/index.html            
fi
else
check="${check}, no dbhost=192.168.2.129"
fi


if grep 'dbport=3306' /var/log/networkbench/php-agent.log > /dev/null 2>&1;then
echo -e "dbport=3306 passed"
	if [ $count -eq 3 ];then
	echo "<tr class='success'><td>$file验证</td><td> dbport=3306验证</td><td>成功</td><td style='width:100%；word-wrap:break-word;'>dbport=3306验证成功</td></tr>" >>/docker/log/index.html            
fi
else
check="${check}, no dbport=3306"
fi

if grep 'dbname=test' /var/log/networkbench/php-agent.log > /dev/null 2>&1;then
echo -e "dbname=test passed"
	if [ $count -eq 3 ];then
	echo "<tr class='success'><td>$file验证</td><td> dbname=test验证</td><td>成功</td><td style='width:100%；word-wrap:break-word;'>dbname=test验证成功</td></tr>" >>/docker/log/index.html            
fi
else
check="${check}, no dbname=test"
fi

if grep 'statement=select' /var/log/networkbench/php-agent.log > /dev/null 2>&1;then
echo -e "statement=select passed"
	if [ $count -eq 3 ];then
	echo "<tr class='success'><td>$file验证</td><td> statement=select验证</td><td>成功</td><td style='width:100%；word-wrap:break-word;'>statement=select验证成功</td></tr>" >>/docker/log/index.html            
fi
else
check="${check}, no statement=select"
fi


