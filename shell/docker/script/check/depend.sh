#! /bin/bash

#check="TRUE" 代表验证成功，check=其他代表失败

#grep返回值：   成功，返回0；  失败，文件存在，模板字符串不存在，返回1；  失败，文件不存在，返回2；
file=$2
count=$1
if /usr/local/php/bin/php -m|grep -w networkbench > /dev/null 2>&1; then
	echo "networkbench passed"
	if [ $count -eq 3 ]
	then
		echo "<tr class='success'><td>$file验证</td><td>networkbench模块验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>networkbench模块验证成功</td></tr>" >>/docker/log/index.html
	fi
else
	check="${check}, no networkbench"
fi

if /usr/local/php/bin/php -m|grep -w pdo_mysql > /dev/null 2>&1; then
	echo "pdo_mysql passed"
	if [ $count -eq 3 ]
	then
		echo "<tr class='success'><td>$file验证</td><td>pdo_mysql模块验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>pdo_mysql模块验证成功</td></tr>" >>/docker/log/index.html
	fi
else
	check="${check}, no pdo_mysql"
fi
if /usr/local/php/bin/php -m|grep -w mysqli > /dev/null 2>&1; then
	echo "mysqli passed"
	if [ $count -eq 3 ]
	then
		echo "<tr class='success'><td>$file验证</td><td>mysqli模块验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>mysqli模块验证成功</td></tr>" >>/docker/log/index.html
	fi
else
	check="${check}, no mysqli"
fi

if /usr/local/php/bin/php -m|grep -wi SQLite3 > /dev/null 2>&1; then
	echo "SQLite3 passed"
	if [ $count -eq 3 ]
	then
		echo "<tr class='success'><td>$file验证</td><td>SQLite3模块验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>SQLite3模块验证成功</td></tr>" >>/docker/log/index.html
	fi
else
	check="${check}, no SQLite3"
fi


if /usr/local/php/bin/php -m|grep -w pgsql > /dev/null 2>&1; then
	echo "pgsql passed"
	if [ $count -eq 3 ]
	then
		echo "<tr class='success'><td>$file验证</td><td>pgsql模块验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>pgsql模块验证成功</td></tr>" >>/docker/log/index.html
	fi
else
	check="${check}, no pgsql"
fi



if [[ ${php} < 7.0 ]]; then
if /usr/local/php/bin/php -m|grep -w memcache > /dev/null 2>&1; then
	echo "memcache passed"
	if [ $count -eq 3 ]
	then
		echo "<tr class='success'><td>$file验证</td><td>memcache模块验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>memcache模块验证成功</td></tr>" >>/docker/log/index.html
	fi
else
	check="${check}, no memcache"
fi
fi

if /usr/local/php/bin/php -m|grep -w memcached > /dev/null 2>&1; then
	echo "memcached passed"
	if [ $count -eq 3 ]
	then
		echo "<tr class='success'><td>$file验证</td><td>memcached模块验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>memcached模块验证成功</td></tr>" >>/docker/log/index.html
	fi
else
	check="${check}, no memcached"
fi

if /usr/local/php/bin/php -m|grep -w redis > /dev/null 2>&1; then
	echo "redis passed"
	if [ $count -eq 3 ]
	then
		echo "<tr class='success'><td>$file验证</td><td>redis模块验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>redis模块验证成功</td></tr>" >>/docker/log/index.html
	fi
else
	check="${check}, no redis"
fi


if [[ ${php} < 7.0 ]]; then
if /usr/local/php/bin/php -m|grep -w mongo > /dev/null 2>&1; then
	echo "mongo passed"
	if [ $count -eq 3 ]
	then
		echo "<tr class='success'><td>$file验证</td><td>mongo模块验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>mongo模块验证成功</td></tr>" >>/docker/log/index.html
	fi
else
	check="${check}, no mongo"
fi
	fi

if /usr/local/php/bin/php -m|grep -w mbstring > /dev/null 2>&1; then
	echo "mbstring passed"
	if [ $count -eq 3 ]
	then
		echo "<tr class='success'><td>$file验证</td><td>mbstring模块验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>mbstring模块验证成功</td></tr>" >>/docker/log/index.html
	fi
else
	check="${check}, no mbstring"
fi


if [[ ${php} = 5.3 ]];then
	if /usr/local/php/bin/php -m|grep -wi sqlite > /dev/null 2>&1; then
		echo "sqlite passed"
		if [ $count -eq 3 ]
		then
			echo "<tr class='success'><td>$file验证</td><td>sqlite模块验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>sqlite模块验证成功</td></tr>" >>/docker/log/index.html
		fi
	else
		check="${check}, no sqlite"
	fi
fi

if [[ ${php} > 5.4 ]]; then
	if /usr/local/php/bin/php -m|grep -wi opcache > /dev/null 2>&1; then
		echo "opcache passed"
		if [ $count -eq 3 ]
		then
			echo "<tr class='success'><td>$file验证</td><td>opcache模块验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>opcache模块验证成功</td></tr>" >>/docker/log/index.html
		fi
	else
		check="${check}, no opcache"
	fi 
fi


function gt_php55(){
	if [[ ${php} > 5.5 ]]; then
		if /usr/local/php/bin/php -m|grep -wi $1 > /dev/null 2>&1; then
			echo "$1 passed"
			if [ $count -eq 3 ]
			then
				echo "<tr class='success'><td>$file验证</td><td>$1模块验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>$1模块验证成功</td></tr>" >>/docker/log/index.html
			fi
		else
			check="${check}, no $1"
		fi 
	fi
}

gt_php55 pdo


if [[ ${php} > 5.5 ]]; then
	if ls /root/|grep vendor > /dev/null 2>&1;then
			echo "amqplib passed"
			if [ $count -eq 3 ]
			then
				echo "<tr class='success'><td>$file验证</td><td>amqplib模块验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>amqplib模块验证成功</td></tr>" >>/docker/log/index.html
			fi
		else
			check="${check}, no amqplib"
	fi 
fi


if [[ ${php} > 5.6 ]]; then
	if /usr/local/php/bin/php -m|grep -wi mongodb > /dev/null 2>&1; then
		echo "mongodb passed"
		if [ $count -eq 3 ]
		then
			echo "<tr class='success'><td>$file验证</td><td>mongodb模块验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>mongodb模块验证成功</td></tr>" >>/docker/log/index.html
		fi
	else
		check="${check}, no mongodb"
	fi 
fi

function mq_modem(){
	if [[ ${php} < 7.1 ]]; then
		if /usr/local/php/bin/php -m|grep -wi $1 > /dev/null 2>&1; then
			echo "$1 passed"
			if [ $count -eq 3 ]
			then
				echo "<tr class='success'><td>$file验证</td><td>$1模块验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>$1模块验证成功</td></tr>" >>/docker/log/index.html
			fi
		else
			check="${check}, no $1"
		fi 
	fi
}

mq_modem Stomp
mq_modem amqp
