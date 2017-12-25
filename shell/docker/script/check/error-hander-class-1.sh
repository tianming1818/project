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

if  grep  'error|status=200' /var/log/networkbench/php-agent.log > /dev/null 2>&1;then
	echo "error|status=200  passed"
	if [ $count -eq 3 ]
	then
		echo "<tr class='success'><td>$file验证</td><td>error|status=200验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>error|status=200成功</td></tr>" >>/docker/log/index.html
	fi
else
	check="${check}, no error|status=200"
	
fi

if  grep  'cls=USER_ERROR' /var/log/networkbench/php-agent.log > /dev/null 2>&1;then
	echo "cls=USER_ERROR  passed"
	if [ $count -eq 3 ]
	then
		echo "<tr class='success'><td>$file验证</td><td>cls=USER_ERROR验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>cls=USER_ERROR成功</td></tr>" >>/docker/log/index.html
	fi
else
	check="${check}, no cls=USER_ERROR"
	
fi

if  grep  'msg=Incorrect parameters' /var/log/networkbench/php-agent.log > /dev/null 2>&1;then
	echo "msg=Incorrect parameters  passed"
	if [ $count -eq 3 ]
	then
		echo "<tr class='success'><td>$file验证</td><td>msg=Incorrect parameters验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>msg=Incorrect parameters成功</td></tr>" >>/docker/log/index.html
	fi
else
	check="${check}, no msg=Incorrect parameters"
	
fi








