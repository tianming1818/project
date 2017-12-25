#! /bin/bash

webserver=$1
php=$2
ts=$3
agent=$4
#$5判定测试本地mysql-dbname mysql-port环境
container=$5
version2="php$2"

echo "<tr><th>测试项</th><th>子功能</th><th>测试结果</th><th>详细信息</th></tr>" >>/docker/log/index.html

#将dc地址改为beta环境
# echo   " " > /etc/hosts



#修改hosts文件内网dc地址
echo   "10.194.0.3 redirect.networkbench.com" > /etc/hosts
if grep '10.194.0.3 redirect.networkbench.com' /etc/hosts > /dev/null 2>&1;then
	echo '<tr class="success"><td>DC地址验证</td><td>DC地址验证</td><td>成功</td><td style="width:100%;word-wrap:break-word;">DC地址验证成功</td></tr>' >>/docker/log/index.html
else
	cat /etc/hosts >> /docker/log/${webserver}-${php}-${ts}-hosts.html
	echo '<tr class="failed"><td>DC地址验证</td><td>DC地址验证</td><td>失败</td><td style="width:100%;word-wrap:break-word;">DC地址验证失败退出<a href="${webserver}-${php}-${ts}-hosts.html" target=framel>详情请点击</a></td></tr>' >>/docker/log/index.html
fi

#1. 更新探针
rpm -e tingyun-agent-php
echo "update agent version to ${agent}"
rpm -Uvh /docker/agent/tingyun-agent-php-${agent}.x86_64.rpm
if [ $? -eq 0 ]
then
	echo '<tr class="success"><td>安装探针</td><td>安装探针</td><td>成功</td><td style="width:100%;word-wrap:break-word;">探针更新成功</td></tr>' >>/docker/log/index.html
else
	echo '<tr class="failed"><td>安装探针</td><td>安装探针</td><td>失败</td><td style="width:100%;word-wrap:break-word;">探针更新失败</td></tr>' >>/docker/log/index.html
fi

#2设置networkbench.ini为日志级别为debug，并开启审计模式
if [[ -f /etc/php.d/networkbench.ini ]];then
	sed -i 's@nbs.agent_log_level = "info"@nbs.agent_log_level = "debug"@' /etc/php.d/networkbench.ini
	sed -i 's@nbs.daemon_log_level = "info"@nbs.daemon_log_level = "debug"@' /etc/php.d/networkbench.ini
	sed -i 's@nbs.audit_mode = false@nbs.audit_mode = true@' /etc/php.d/networkbench.ini

elif [[ -f /etc/php.ini ]];then
	sed -i 's@nbs.agent_log_level = "info"@nbs.agent_log_level = "debug"@' /etc/php.ini
	sed -i 's@nbs.daemon_log_level = "info"@nbs.daemon_log_level = "debug"@' /etc/php.ini
	sed -i 's@nbs.audit_mode = false@nbs.audit_mode = true@' /etc/php.ini

else
	echo  the networkbench.ini no exists
	exit
fi

source /etc/rc.local
#3. 清除日志
rm -rf /docker/tmp
mkdir /docker/tmp
echo "" > /var/log/networkbench/daemon.log
echo "" >/var/log/networkbench/php-agent.log

#4. 使用valgrind启动httpd或php-fpm 
export USE_ZEND_ALLOC=0
export ZEND_DONT_UNLOAD_MODULES=1


if [ "$webserver" == "apache" ] 
	then
	source /etc/rc.local
	valgrind --tool=memcheck --leak-check=full --log-file=/docker/tmp/leak.log /usr/sbin/httpd
	sleep 2
fi

if [ "${webserver}" == "nginx" ] && [ "${version2}" != "php7.1" ]
	then
		/etc/init.d/nginx start
		valgrind --tool=memcheck --leak-check=full --log-file=/docker/tmp/leak.log /usr/local/php/sbin/php-fpm
	
	elif [ "${webserver}" == "nginx" ];then
		/usr/sbin/nginx -c /etc/nginx/nginx.conf
		valgrind --tool=memcheck --leak-check=full --log-file=/docker/tmp/leak.log /usr/local/php/sbin/php-fpm
	#valgrind --tool=memcheck --leak-check=full --log-file=/docker/tmp/leak.log /usr/local/php/sbin/php-fpm  -g /usr/local/php/var/run/php-fpm.pid
fi



sleep 1

if [ `netstat -lntup|grep 80|wc -l` -eq 1 ]
	then
	echo '<tr class="success"><td>启动Web Server and 80 Port</td><td>启动Web Server and 80 Port</td><td>成功</td><td style="width:100%;word-wrap:break-word;">Web Server and 80 Port启动成功</td></tr>' >>/docker/log/index.html
else
	echo '<tr class="failed"><td>启动Web Server and 80 Port</td><td>启动Web Server and 80 Port</td><td>失败</td><td style="width:100%;word-wrap:break-word;">Web Server and 80 Port启动失败</td></tr>' >>/docker/log/index.html
fi	

sleep 3
if [ `ps -ef|grep valgrind|wc -l` -gt 2 ]
	then
	echo '<tr class="success"><td>启动valgrind</td><td>启动valgrind</td><td>成功</td><td style="width:100%;word-wrap:break-word;">valgrind 启动成功</td></tr>' >>/docker/log/index.html
else
	echo '<tr class="failed"><td>启动valgrind</td><td>启动valgrind</td><td>失败</td><td style="width:100%;word-wrap:break-word;">valgrind 启动失败</td></tr>' >>/docker/log/index.html
fi

sleep 1

#5. 运行测试脚本
#1）至少运行3次info.php（目的是拉起并初始化汇总进程）
for count in {1..3}
do
   curl http://127.0.0.1/info.php > /dev/null 2>&1
   sleep 1
done

#验证dc是否可用
# if grep 'ERROR' /var/log/networkbench/daemon.log > /dev/null 2>&1;then	
	# echo "DC ERROR"	
	# cat /var/log/networkbench/daemon.log >>/docker/log/${webserver}-${php}-${ts}-daemon.html
	# echo '<tr class="failed"><td>DC验证</td><td>DC验证</td><td>失败</td><td style="width:100%;word-wrap:break-word;">DC验证失败退出<a href="${webserver}-${php}-${ts}-daemon.html" target=framel>详情请点击</a></td></tr>' >>/docker/log/index.html
	# exit
# else
	# echo "DC OK"
	# echo '<tr class="success"><td>DC验证</td><td>DC验证</td><td>成功</td><td style="width:100%;word-wrap:break-word;">DC验证成功</td></tr>' >>/docker/log/index.html
# fi

#验证应用是否被server端关闭
curl http://127.0.0.1/info.php > /dev/null 2>&1
if grep 'agent disabled by server' /var/log/networkbench/php-agent.log > /dev/null 2>&1;then	
	echo "Agent disable by server"
	cat /var/log/networkbench/php-agent.log >>/docker/log/${webserver}-${php}-${ts}-agent.html
	echo "<tr class='failed'><td>Agent disable by server验证</td><td>Agent disable by server验证</td><td>失败</td><td style='width:100%;word-wrap:break-word;'>Agent disable by server验证失败退出<a href=${webserver}-${php}-${ts}-agent.html  target=framel>详情请点击</a></td></tr>" >>/docker/log/index.html
	exit
else
	echo "Agent enable by server"
	cat /var/log/networkbench/php-agent.log >>/docker/log/${webserver}-${php}-${ts}-agent.html
	echo "<tr class='success'><td>Agent enable by server验证</td><td>Agent enable by server验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>Agent enable by server验证成功</td></tr>" >>/docker/log/index.html
fi




#2）遍历所有的集成测试用例
#source /docker/script/integration.sh

#3）本地测试mysql-dbname-port用例
if [ "${container}" == "mysql-dbname-port" ];then
/etc/init.d/memcached start

sleep 1

/etc/init.d/mongod start

sleep 1

/etc/init.d/mysqld start

sleep 1

/etc/init.d/redis start

source /docker/script/mysql-dbname-port.sh 

else
#4）遍历所有的功能测试用例
source /docker/script/dispatch.sh

fi

#5）至少运行8次info.php（保证 worker进程能充分退出，新启动的worker进程数据可以丢弃）
for count in {1..8}
do
   curl http://127.0.0.1/info.php > /dev/null 2>&1
done

echo ""

#6停止mysql
if [[ ${php} > 5.4 ]];then

/etc/rc.d/init.d/mysqld stop

fi

#7停止mysql memcahched mongod服务
[ "${container}" = "mysql-dbname-port" ] && /etc/init.d/memcached stop  

[ "${container}" = "mysql-dbname-port" ] && /etc/rc.d/init.d/mongod stop
sleep 1

[ "${container}" = "mysql-dbname-port" ] && /etc/rc.d/init.d/mysqld stop

[ "${container}" = "mysql-dbname-port" ] && /etc/rc.d/init.d/redis stop

#8停止valgrind
[ "${webserver}" = "apache" ] && service httpd stop
[ "${webserver}" = "nginx" ] && pidof valgrind|xargs kill -9

#9分析valgrind日志
#查找内存泄漏和崩溃（debug版本有强制8字节泄漏和一个强制崩溃用例）
#如果有内存泄漏，将/docker/tmp/leak.log复制为/docker/log/${webserver}-php${php}-${ts}-leak.log

echo "check if there exist specified nbprof error ( 8k leak ) within the leak log"

if [ `grep -A 6 ' 8 bytes in 1 blocks ' /docker/tmp/leak.log | grep 'zm_startup_nbprof' |wc -l` -ge 1 ]
then
	echo "Pass"
	((PassNum++))
	echo "<tr class='success'><td>8字节内存泄漏验证</td><td>8字节内存泄漏验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>8字节内存泄漏验证成功</td></tr>" >>/docker/log/index.html
else
    echo -e "\033[31mFailed,cannot find specified nbprof leak \033[0m"
	((FailedNum++))
    cp /docker/tmp/leak.log /docker/log/${webserver}-php${php}-${ts}-leak.html
	chmod 755 /docker/log/${webserver}-php${php}-${ts}-leak.html
	echo "<tr class='failed'><td>8字节内存泄漏验证验证</td><td>8字节内存泄漏验证</td><td>失败</td><td style='width:100%;word-wrap:break-word;'>无8字节内存泄漏，验证失败<a href=${webserver}-php${php}-${ts}-leak.html  target=framel>详情请点击</a></td></tr>" >>/docker/log/index.html		
fi  


echo "check if there exist external nbprof errors or not"
if [ `cat /docker/tmp/leak.log |grep nbprof |grep -v nb_execute|grep -v nb_compile_file|grep -v nb_execute_ex | grep -v zm_startup_nbprof |grep  -v  nb_execute_internal|wc -l` -ge 1 ]
then
        echo  -e "\033[31m Fail \033[0m"
		((FailedNum++))
		cp /docker/tmp/leak.log /docker/log/${webserver}-php${php}-${ts}-leak.html
		chmod 755 /docker/log/${webserver}-php${php}-${ts}-leak.html
		echo "<tr class='failed'><td>nbprof内存泄漏验证</td><td>nbprof内存泄漏验证</td><td>失败</td><td style='width:100%;word-wrap:break-word;'>nbprof内存泄漏验证<a href=${webserver}-php${php}-${ts}-leak.html  target=framel>详情请点击</a></td></tr>" >>/docker/log/index.html
else
        echo "Pass"
		((PassNum++))
		echo "<tr class='success'><td>nbprof内存泄漏验证</td><td>nbprof内存泄漏验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>nbprof内存泄漏验证成功</td></tr>" >>/docker/log/index.html
fi

echo "<tr><th>所有测试项</th><th>成功数量</th><th>失败数量</th></tr>" >>/docker/log/index.html
AllNum=$((FailedNum+PassNum))
echo "<td>$AllNum</td><td>$PassNum</td><td>$FailedNum</td>" >>/docker/log/index.html


#curl http://127.0.0.1/crush.php >/dev/null 2>&1
#crush_num=`grep SIGSEGV /var/log/networkbench/php-agent.log|wc -l`
#echo "crush num is :$crush_num"
#if [ $crush_num -le 1 ] 
#        then
#        echo -e "\033[31mNot found the force crush \033[0m"
#		cp /docker/tmp/leak.log /docker/log/${webserver}-php${php}-${ts}-leak.log
#elif [ $crush_num -eq 2 ] 
#        then
#        echo "Force crush PASS"
#elif [ $crush_num -gt 2 ] 
#        then
#        echo -e "\033[31mFound more crush info \033[0m"
#		cp /docker/tmp/leak.log /docker/log/${webserver}-php${php}-${ts}-leak.log
#fi

echo "-----------------"


