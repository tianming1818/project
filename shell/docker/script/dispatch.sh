#! /bin/bash

#为了兼容opcache，opcache在5.5以上才有，每个测试用例至少循环执行3次
#每次执行前清除php-agent.log，执行后验证php-agent.log内容
#当不能通过验证时，将php-agent.log保存到验证结果文件夹并改名为对应测试用例的名称

# 不判断php版本，所有版本上均运行
PassNum=0
FailedNum=0
#还有自定义web过程的用例未添加，原因是报表该功能未上线，暂无法测试
#"action-naming-rule" "action-naming-rule-contains" "action-naming-rule-contains-ok" "action-naming-rule-endwith" "action-naming-rule-equ" "action-naming-rule-match-method" "action-naming-rule-param" "action-naming-rule-param-body" "action-naming-rule-param-header" "action-naming-rule-param-url" "action-naming-rule-regex" "action-naming-rule-regx-invalid" "action-naming-rule-regx-valid" "action-naming-rule-startwith"

for name in  "depend" "action-naming-rewrite" "action-naming-ci" "action-naming-yii"  "action-naming-zend"  "action-naming-joomla" "action-naming-thinkPHP" "trans-thrift"  "trans-nusoap" "trans-curl-callback-3" "trans-curl-callback-2" "trans-curl-callback-1" "trans-curl_exec" "trans-file_get_contents-context" "trans-file_get_contents" "trans-fopen-context" "trans-fopen" "rum-ob_get_flush" "rum-ob_get_contents" "rum-ob_end_flush" "rum-ob_start" "rum-ob_flush" "rum-with-gzip"  "rum-by-head" "rum-by-title"  "error-hander-class-1" "error-hander-proc-warn" "error-hander-proc-error" "error-nohander-warn" "error-nohander-error" "error-nocatch-nohander" "error-catch-exception" "error-nocatch-exception" "error-parse" "comp-compile" "comp-namespace" "cpu-mem" "comp-class" "comp-function" "trace"  "external-file_get_contents" "external-fopen" "external-nusoap" "external-curl_multi_exec" "external-error-curl-status" "external-error-curl-net" "external-curl_exec"  "external-soapclient3" "external-soapclient2" "external-soapclient" "external-httprequest" "nosql-predis" "nosql-redis" "nosql-memcached"  "db-pg-insert" "db-pg-delete" "db-pg-prepare" "db-pg-params-error" "db-pg-params" "db-pg-query-error" "db-pg-query" "db-sqlite3-query" "db-mysqli-statement2-proc" "db-mysqli-statement-proc" "db-mysqli-query-proc" "db-mysqli-statement-error" "db-mysqli-statement2" "db-mysqli-statement" "db-mysqli-query-error" "db-mysqli-query" "db-pdo-statement-error" "db-pdo-statement" "db-pdo-query-error" "db-pdo-query" "action-naming-phpwind" "nosql-redis-yii" "api-cross" "db-pdo-mysql-dsnalias" "db-pdo-mysql-dsnall" "db-pdo-mysql-exec"  "db-pdo-mysql-host" "db-pdo-mysql-hostport" "db-mysqli-conn-host"  "db-mysqli-conn-all" "db-mysqli-conn-hostport" "db-mysqli-real-conn" "db-mysqli-select-db" "db-mysqli-change-user" "db-mysqli-oop-all" "db-mysqli-oop-host"  "db-mysqli-oop-hostport"  "db-mysqli-oop-conn" "db-mysqli-oop-real-conn" "db-mysqli-oop-select-db" "db-mysqli-oop-change-user" "db-mysqli-conn-host"  "db-mysqli-conn-all" "db-mysqli-conn-hostport" "db-pdo-mysql-host" "db-pdo-mysql-hostport" "db-pdo-mysql-dsnalias" "db-pdo-mysql-exec" "db-pdo-mysql-stmtexec" "nosql-redis-conn-host" "nosql-redis-conn-hostport" "nosql-redis-pconn-host" "nosql-redis-pconn-hostport" "nosql-redis-open-host" "nosql-redis-open-hostport" "nosql-redis-popen-host" "nosql-redis-popen-hostport" "nosql-redis-select"  "trans-curl-header";

#for name in "depend" "action-naming-rewrite" "action-naming-ci" "action-naming-yii"  "action-naming-zend" "action-naming-wordpress" "action-naming-joomla" "action-naming-thinkPHP" "trans-thrift"  "trans-nusoap" "trans-curl-callback-3" "trans-curl-callback-2" "trans-curl-callback-1" "trans-curl_exec" "trans-file_get_contents-context" "trans-file_get_contents" "trans-fopen-context" "trans-fopen" "rum-ob_get_flush" "rum-ob_get_contents" "rum-ob_end_flush" 

 do
	echo ""
	echo "check ${name}..."
	err_count=0
	for count in {1..3}; do
		echo "" > /var/log/networkbench/php-agent.log
		rm -f /docker/tmp/wget.log
		if  [ -f /docker/web/${name}.php -a ${name} != "api-cross" ];
			then
			wget http://127.0.0.1/${name}.php -q -t 1 -O /docker/tmp/wget.log
			echo "访问的应用地址：http://127.0.0.1/${name}.php" >>/docker/tmp/wget.log
		
		elif [ ${name} == "trans-thrift" ]; then
			wget http://127.0.0.1/trans-thrift/thrift/client.php -q -t 1 -O /docker/tmp/wget.log
			echo "访问的应用地址：http://127.0.0.1/trans-thrift/thrift/client.php" >>/docker/tmp/wget.log
			
		elif [ ${name} == "external-thrift" ]; then
			wget "http://127.0.0.1/external-thrift/client.php" -q -t 1 -O /docker/tmp/wget.log
			echo "访问的应用地址：http://127.0.0.1/external-thrift/client.php" >>/docker/tmp/wget.log
		elif [ ${name} == "external-error-thrift" ];then
			wget "http://127.0.0.1/external-error-thrift/client.php" -q -t 1 -O /docker/tmp/wget.log
			echo "访问的应用地址：http://127.0.0.1/external-error-thrift/client.php" >>/docker/tmp/wget.log
		elif [ ${name} == "action-naming-yii2" ];then
			wget "http://127.0.0.1/action-naming-yii2/frontend/web/index.php?r=thread/index&boardid=4" -q -t 1 -O /docker/tmp/wget.log
			echo "访问的应用地址：http://127.0.0.1/action-naming-yii2/frontend/web/index.php?r=thread/index&boardid=4" >>/docker/tmp/wget.log
		elif [ ${name} == "action-naming-yii" ];then						
			wget "http://127.0.0.1/action-naming-yii/demos/blog/index.php" -q -t 1 -O /docker/tmp/wget.log
			echo "访问的应用地址：http://127.0.0.1/action-naming-yii/demos/blog/index.php" >>/docker/tmp/wget.log
		elif [ ${name} == 'action-naming-ci' -o ${name} == 'action-naming-joomla' -o ${name} == 'action-naming-thinkPHP' -o ${name} == 'action-naming-drupal' -o ${name} == 'action-naming-zend' -o ${name} == 'action-naming-rewrite' ];then
			#zend框架在多个容器中正常运行需要配置cache的读写权限
			chmod 777 -R /docker/web/action-naming-zend/cache/
			wget "http://127.0.0.1/${name}/index.php" -q -t 1 -O /docker/tmp/wget.log
			echo "访问的应用地址：http://127.0.0.1/${name}/index.php" >>/docker/tmp/wget.log
		elif [ ${name} == "action-naming-phpwind" ];then
			wget "http://127.0.0.1/action-naming-phpwind/windframework-master/demos/helloworld/index.php" -q -t 1 -O /docker/tmp/wget.log	
			echo "访问的应用地址：http://127.0.0.1/action-naming-phpwind/windframework-master/demos/helloworld/index.php" >>/docker/tmp/wget.log

		elif [ ${name} == "nosql-redis-yii" ];then
			wget "http://127.0.0.1/${name}/web/index.php?r=redis/index" -q -t 1 -O /docker/tmp/wget.log
			echo "访问的应用地址：http://127.0.0.1/${name}/web/index.php?r=redis/index" >>/docker/tmp/wget.log

		elif [ ${name} == "api-cross" ];then						
			valgrind --tool=memcheck --leak-check=full --log-file=/docker/tmp/api-leak.log php /docker/web/api-cross-client.php >/docker/tmp/wget.log
			echo "命令行访问的应用：valgrind --tool=memcheck --leak-check=full --log-file=/tmp/api-leak.log php /docker/web/api-cross-client.php" >>/docker/tmp/wget.log
			echo "##############this api leak start#################" >>/docker/tmp/leak.log
			cat /docker/tmp/api-leak.log >>/docker/tmp/leak.log
			echo "##############this api leak stop#################" >>/docker/tmp/leak.log
		else
			wget http://127.0.0.1/api-cross-server.php -q -t 1 -O /docker/tmp/wget.log
			echo "访问的应用地址：http://127.0.0.1/api-cross-server.php" >>/docker/tmp/wget.log
		fi
		sleep 1
		check="TRUE"
		source /docker/script/check/${name}.sh $count ${name}
		if [[ ${check} = "TRUE" ]]; then
			echo "${name} PASSED"
			echo "${webserver}-php${php}-${ts}-${name} PASSED" >> /docker/log/verify.log			
		else
			((err_count++))
			echo -e "\033[31m ${name} FAIL: ${check} \033[0m"
			if [[ `grep -c 'rum.html' /docker/script/check/${name}.sh` -ge 1 ]];then
				echo "${webserver}-php${php}-${ts}-${name} FAIL: ${check}, see agent detail in ${htmlname}" >> /docker/log/verify.log
			else
			logname="/docker/log/${webserver}-php${php}-${ts}-php-agent-${name}.html"
			cat /var/log/networkbench/php-agent.log >> ${logname}
			echo "${webserver}-php${php}-${ts}-${name} FAIL: ${check}, see agent detail in ${logname}" >> /docker/log/verify.log
			wgetname="/docker/log/${webserver}-php${php}-${ts}-wget-${name}.html"
			cat /docker/tmp/wget.log >> ${wgetname}
			echo "see wget detail in ${wgetname}" >> /docker/log/verify.log
			fi
		fi
			if [ $count -eq 3 ]
			then
				echo -e "\e[1;32mAll php version error is $err_count\e[0m"
			fi
	done
		if [ $err_count -gt 0 ] 
			then
				((FailedNum++))
				echo "<tr class='failed'><td>${name}验证</td><td>${check}验证</td><td>失败</td><td style='width:100%;word-wrap:break-word;'>${check}失败，更多信息请点击<br><a href=${webserver}-php${php}-${ts}-php-agent-${name}.html target=framel>错误信息</a><br><a href=${webserver}-php${php}-${ts}-wget-${name}.html target=framel>访问信息</a></td></tr>" >>/docker/log/index.html
		else
				((PassNum++))
				echo "<tr class='success'><td>${name}验证</td><td>${name}验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>${name}成功</td></tr>" >>/docker/log/index.html
	fi
	sleep 1
done



#以下为按照特定版本判断



#php5.3 ~ php7.0的版本才运行,stomp, amqp两个模块，activemq和amqp的测试用例在此运行
if [[ ${php} < 7.1 ]]; then
for name in "mq-rabbitmq-set-hostport" "mq-rabbitmq-set-host" "mq-rabbitmq-queue-setname" "mq-rabbitmq-queue-bind" "mq-rabbitmq-exchange-temp" "mq-rabbitmq-exchange-publish" "mq-rabbitmq-exchange-nosetname" "mq-rabbitmq-construct-rtkey-dot" "mq-rabbitmq-construct-hostport-topic" "mq-rabbitmq-construct-hostport" "mq-rabbitmq-construct-hostport-Fanout" "mq-rabbitmq-construct-hostport-direct" "mq-rabbitmq-construct-host" "mq-activemq-topic-procedural-hostport" "mq-activemq-topic-procedural-host" "mq-activemq-topic-construct-hostport" "mq-activemq-topic-construct-host" "mq-activemq-procedural-hostport" "mq-activemq-procedural-host" "mq-activemq-construct-hostport" "mq-activemq-construct-host" "action-naming-cake" "action-naming-wordpress";do
echo ""
	echo "check ${name}..."
	err_count=0
	for count in {1..3}; do
		echo "" > /var/log/networkbench/php-agent.log
		rm -f /docker/tmp/wget.log
		if  [ -f /docker/web/${name}.php ];
			then
			wget http://127.0.0.1/${name}.php -q -t 1 -O /docker/tmp/wget.log
			echo "访问的应用地址：http://127.0.0.1/${name}.php" >>/docker/tmp/wget.log
		elif [ ${name} == "action-naming-yii2" ];then
			wget "http://127.0.0.1/action-naming-yii2/frontend/web/index.php?r=thread/index&boardid=4" -q -t 1 -O /docker/tmp/wget.log
			echo "访问的应用地址：http://127.0.0.1/action-naming-yii2/frontend/web/index.php?r=thread/index&boardid=4" >>/docker/tmp/wget.log
		elif [ ${name} == "action-naming-wordpress" ];then
			wget "http://127.0.0.1/${name}/wp-admin/" -q -t 1 -O /docker/tmp/wget.log
			echo "访问的应用地址：http://127.0.0.1/${name}/wp-admin/" >> /docker/tmp/wget.log
		elif [ ${name} == 'action-naming-ci' -o ${name} == 'action-naming-cake' -o ${name} == 'action-naming-joomla' -o ${name} == 'action-naming-thinkPHP' -o ${name} == 'action-naming-drupal' -o ${name} == 'action-naming-zend' -o ${name} == 'action-naming-rewrite' ];then
			#zend框架在多个容器中正常运行需要配置cache的读写权限
			chmod 777 -R /docker/web/action-naming-zend/cache/
			wget "http://127.0.0.1/${name}/index.php" -q -t 1 -O /docker/tmp/wget.log
			echo "访问的应用地址：http://127.0.0.1/${name}/index.php" >>/docker/tmp/wget.log
		else
			wget http://127.0.0.1/${name} -q -t 1 -O /docker/tmp/wget.log
			echo "访问的应用地址：http://127.0.0.1/${name}" >>/docker/tmp/wget.log
		fi
		check="TRUE"
		source /docker/script/check/${name}.sh $count ${name}
		if [[ ${check} = "TRUE" ]]; then
			echo "${name} PASSED"
			echo "${webserver}-php${php}-${ts}-${name} PASSED" >> /docker/log/verify.log
		else
			((err_count++))
			echo -e "\033[31m ${name} FAIL: ${check} \033[0m"
			logname="/docker/log/${webserver}-php${php}-${ts}-php-agent-${name}.html"
			cat /var/log/networkbench/php-agent.log >> ${logname}
			echo "${webserver}-php${php}-${ts}-${name} FAIL: ${check}, see agent detail in ${logname}" >> /docker/log/verify.log
			wgetname="/docker/log/${webserver}-php${php}-${ts}-wget-${name}.html"
			cat /docker/tmp/wget.log >> ${wgetname}
			echo "see wget detail in ${wgetname}" >> /docker/log/verify.log
		fi
			if [ $count -eq 3 ]
			then
				echo -e "\e[1;32mphp version gt 5.3 error is $err_count\e[0m"
			fi
	done
		if [[ $err_count -gt 0 ]] 
			then
				((FailedNum++))
				echo "<tr class='failed'><td>${name}验证</td><td>${check}验证</td><td>失败</td><td style='width:100%;word-wrap:break-word;'>${check}失败，更多信息请点击<br><a href=${webserver}-php${php}-${ts}-php-agent-${name}.html target=framel>错误信息</a><br><a href=${webserver}-php${php}-${ts}-wget-${name}.html target=framel>访问信息</a></td></tr>" >>/docker/log/index.html
		else	
				((PassNum++))
				echo "<tr class='success'><td>${name}验证</td><td>${name}验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>${name}成功</td></tr>" >>/docker/log/index.html
	
	fi
done
fi

#php5.3-php5.6  ： mysql扩展在7.0上不存在,memcache,mongo扩展不能安装在7.0
if [[ ${php} > 5.2 ]] && [[ ${php} < 7.0 ]]; then

for name in "db-mysql-hostlocal" "nosql-mongo" "db-mysql-query" "db-mysql-query-error" "db-mysql-dbquery" "db-mysql-dbquery-error" "db-mysql-unbuffered-query" "nosql-memcache-proc-pconn" "nosql-memcache-proc-addserver" "nosql-memcache-proc-conn-hostport" "nosql-memcache-oop-addserver" "nosql-memcache-oop-pconn" "nosql-memcache-oop-conn-hostport" "nosql-memcache" "nosql-memcache-pool" "db-mysql-all" "db-mysql-host" "db-mysql-hostport" "db-mysql-db_query" "db-mysql-pconn" "nosql-mongo-collection-getindexinfo" "nosql-mongo-collection-deleteindexes" "nosql-mongo-collection-deleteindex" "nosql-mongo-collection-ensureindex" "nosql-mongo-collection-createindex" "nosql-mongo-collection-findandmodify" "nosql-mongo-collection-save" "nosql-mongo-collection-group" "nosql-mongo-collection-findone" "nosql-mongo-collection-find" "nosql-mongo-collection-remove" "nosql-mongo-collection-update" "nosql-mongo-collection-drop" "nosql-mongo-collection-distinct" "nosql-mongo-collection-count" "nosql-mongo-collection-batchinsert" "nosql-mongo-collection-insert" "nosql-mongo-db-command" "nosql-mongo-db-execute" "nosql-mongo-db-drop" "nosql-mongo-client-hostport" "nosql-mongo-client-host" ;do
	echo ""
	echo "check ${name}..."
	err_count=0
	for count in {1..3}; do
		echo "" > /var/log/networkbench/php-agent.log
		rm -f /docker/tmp/wget.log
		wget http://127.0.0.1/${name}.php -q -t 1 -O /docker/tmp/wget.log
		echo "访问的应用地址：http://127.0.0.1/${name}.php" >>/docker/tmp/wget.log
		check="TRUE"
		source /docker/script/check/${name}.sh $count ${name}
		if [[ ${check} = "TRUE" ]]; then
			echo "${name} PASSED"
			echo "${webserver}-php${php}-${ts}-${name} PASSED" >> /docker/log/verify.log
		else
			((err_count++))
			echo -e "\033[31m ${name} FAIL: ${check} \033[0m"
			logname="/docker/log/${webserver}-php${php}-${ts}-php-agent-${name}.html"
			cat /var/log/networkbench/php-agent.log >> ${logname}
			echo "${webserver}-php${php}-${ts}-${name} FAIL: ${check}, see agent detail in ${logname}" >> /docker/log/verify.log
			wgetname="/docker/log/${webserver}-php${php}-${ts}-wget-${name}.html"
			cat /docker/tmp/wget.log >> ${wgetname}
			echo "see wget detail in ${wgetname}" >> /docker/log/verify.log
		fi
			if [ $count -eq 3 ]
			then
				echo -e "\e[1;32mphp version lt 7.0 error is $err_count\e[0m"
			fi
	done
	if [ $err_count -gt 0 ] 
		then
			((FailedNum++))
			echo "<tr class='failed'><td>${name}验证</td><td>${check}验证</td><td>失败</td><td style='width:100%;word-wrap:break-word;'>${check}失败，更多信息请点击<br><a href=${webserver}-php${php}-${ts}-php-agent-${name}.html target=framel>错误信息</a><br><a href=${webserver}-php${php}-${ts}-wget-${name}.html target=framel>访问信息</a></td></tr>" >>/docker/log/index.html
		else
			((PassNum++))
			echo "<tr class='success'><td>${name}验证</td><td>${name}验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>${name}成功</td></tr>" >>/docker/log/index.html
	fi
done
fi

#php5.3
if [[ ${php} < 5.4 ]]; then

for name in "db-sqlite-query" ; do
	echo ""
	echo "check ${name}..."
	err_count=0
	for count in {1..3}; do
		echo "" > /var/log/networkbench/php-agent.log
		rm -f /docker/tmp/wget.log
		wget http://127.0.0.1/${name}.php -q -t 1 -O /docker/tmp/wget.log
		echo "访问的应用地址：http://127.0.0.1/${name}.php" >>/docker/tmp/wget.log
		check="TRUE"
		source /docker/script/check/${name}.sh $count ${name}
		if [[ ${check} = "TRUE" ]]; then
			echo "${name} PASSED"
			echo "${webserver}-php${php}-${ts}-${name} PASSED" >> /docker/log/verify.log
		else
			((err_count++))
			echo -e "\033[31m ${name} FAIL: ${check} \033[0m"
			logname="/docker/log/${webserver}-php${php}-${ts}-php-agent-${name}.html"
			cat /var/log/networkbench/php-agent.log >> ${logname}
			echo "${webserver}-php${php}-${ts}-${name} FAIL: ${check}, see agent detail in ${logname}" >> /docker/log/verify.log
			wgetname="/docker/log/${webserver}-php${php}-${ts}-wget-${name}.html"
			cat /docker/tmp/wget.log >> ${wgetname}
			echo "see wget detail in ${wgetname}" >> /docker/log/verify.log
		fi
			if [ $count -eq 3 ]
			then
				echo -e "\e[1;32mphp version 5.3 error is $err_count\e[0m"
			fi
	done
	if [ $err_count -gt 0 ] 
		then
			((FailedNum++))
			echo "<tr class='failed'><td>${name}验证</td><td>${check}验证</td><td>失败</td><td style='width:100%;word-wrap:break-word;'>${check}失败，更多信息请点击<br><a href=${webserver}-php${php}-${ts}-php-agent-${name}.html target=framel>错误信息</a><br><a href=${webserver}-php${php}-${ts}-wget-${name}.html target=framel>访问信息</a></td></tr>" >>/docker/log/index.html
		else
			((PassNum++))
			echo "<tr class='success'><td>${name}验证</td><td>${name}验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>${name}成功</td></tr>" >>/docker/log/index.html
	fi
done
fi


#php5.5及其以上到7.1
if [[ ${php} > 5.4 ]]; then
chmod -R 777 /root/
for name in "mq-rabbitmq-publish-queue"  "mq-rabbitmq-publish-exchange"  "mq-rabbitmq-batch-publish-queue" "mq-rabbitmq-batch-publish-exchange" "action-naming-laravel"  ; do
	echo ""
	echo "check ${name}..."
	err_count=0
	for count in {1..3}; do
		echo "" > /var/log/networkbench/php-agent.log
		rm -f /docker/tmp/wget.log
		if [ ${name} == 'action-naming-laravel' ]
			then
			wget "http://127.0.0.1/${name}/index.php" -q -t 1 -O /docker/tmp/wget.log
			echo "访问的应用地址：http://127.0.0.1/${name}/index.php" >>/docker/tmp/wget.log
		else
			wget http://127.0.0.1/${name}.php -q -t 1 -O /docker/tmp/wget.log
			echo "访问的应用地址：http://127.0.0.1/${name}.php" >>/docker/tmp/wget.log
		fi
		check="TRUE"
		source /docker/script/check/${name}.sh $count ${name}
		if [[ ${check} = "TRUE" ]]; then
			echo "${name} PASSED"
			echo "${webserver}-php${php}-${ts}-${name} PASSED" >> /docker/log/verify.log
		else
			((err_count++))
			echo -e "\033[31m ${name} FAIL: ${check} \033[0m"
			logname="/docker/log/${webserver}-php${php}-${ts}-php-agent-${name}.html"
			cat /var/log/networkbench/php-agent.log >> ${logname}
			echo "${webserver}-php${php}-${ts}-${name} FAIL: ${check}, see agent detail in ${logname}" >> /docker/log/verify.log
			wgetname="/docker/log/${webserver}-php${php}-${ts}-wget-${name}.html"
			cat /docker/tmp/wget.log >> ${wgetname}
			echo "see wget detail in ${wgetname}" >> /docker/log/verify.log
		fi
			if [ $count -eq 3 ]
			then
				echo -e "\e[1;32mphp version gt 5.4 error is $err_count\e[0m"
			fi
	done
	if [ $err_count -gt 0 ] 
		then
			((FailedNum++))
			echo "<tr class='failed'><td>${name}验证</td><td>${check}验证</td><td>失败</td><td style='width:100%;word-wrap:break-word;'>${check}失败，更多信息请点击<br><a href=${webserver}-php${php}-${ts}-php-agent-${name}.html target=framel>错误信息</a><br><a href=${webserver}-php${php}-${ts}-wget-${name}.html target=framel>访问信息</a></td></tr>" >>/docker/log/index.html
		else
			if [ ${name} == 'action-naming-laravel' ];then
			((PassNum++))
			echo "<tr class='success'><td>${name}验证</td><td>${name}验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>${name}成功</td></tr>" >>/docker/log/index.html 
		else
			((PassNum++))
			echo "<tr class='success'><td>${name}验证</td><td>${name}验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>${name}成功</td></tr>" >>/docker/log/index.html
		fi
	fi
done
fi


#php5.5~php5.6
if [[ ${php} > 5.4 ]] && [[ ${php} < 7.0 ]];then
	for name in "db-mysql-hostlocal"  ; do
	echo ""
	echo "check ${name}..."
	err_count=0
	for count in {1..3}; do
	echo "" > /var/log/networkbench/php-agent.log
	rm -f /docker/tmp/wget.log
	wget http://127.0.0.1/${name}.php -q -t 1 -O /docker/tmp/wget.log
	echo "访问的应用地址：http://127.0.0.1/${name}.php" >>/docker/tmp/wget.log
	check="TRUE"
	source /docker/script/check/${name}.sh $count ${name}
	if [[ ${check} = "TRUE" ]]; then
			echo "${name} PASSED"
			echo "${webserver}-php${php}-${ts}-${name} PASSED" >> /docker/log/verify.log
		else
			((err_count++))
			echo -e "\033[31m ${name} FAIL: ${check} \033[0m"
			logname="/docker/log/${webserver}-php${php}-${ts}-php-agent-${name}.html"
			cat /var/log/networkbench/php-agent.log >> ${logname}
			echo "${webserver}-php${php}-${ts}-${name} FAIL: ${check}, see agent detail in ${logname}" >> /docker/log/verify.log
			wgetname="/docker/log/${webserver}-php${php}-${ts}-wget-${name}.html"
			cat /docker/tmp/wget.log >> ${wgetname}
			echo "see wget detail in ${wgetname}" >> /docker/log/verify.log
		fi
			if [ $count -eq 3 ]
			then
				echo -e "\e[1;32mphp version gt 5.4 error is $err_count\e[0m"
			fi
		done
		if [ $err_count -gt 0 ] 
		then
			((FailedNum++))
			echo "<tr class='failed'><td>${name}验证</td><td>${check}验证</td><td>失败</td><td style='width:100%;word-wrap:break-word;'>${check}失败，更多信息请点击<br><a href=${webserver}-php${php}-${ts}-php-agent-${name}.html target=framel>错误信息</a><br><a href=${webserver}-php${php}-${ts}-wget-${name}.html target=framel>访问信息</a></td></tr>" >>/docker/log/index.html
		else
			if [ ${name} == 'action-naming-laravel' ];then
			((PassNum++))
			echo "<tr class='success'><td>${name}验证</td><td>${name}验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>${name}成功<br><a href=${webserver}-php${php}-${ts}-php-agent-${name}.html target=framel>详细信息</a><br><a href=${webserver}-php${php}-${ts}-wget-${name}.html target=framel>访问信息</a></td></tr>" >>/docker/log/index.html 
		else
			((PassNum++))
			echo "<tr class='success'><td>${name}验证</td><td>${name}验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>${name}成功</td></tr>" >>/docker/log/index.html
		fi
	fi
done
fi


#php5.5~php7.0





#php7.0
if [[ ${php} > 5.6 ]]; then

for name in "nosql-mongodb-command-host" "nosql-mongodb-command-hostport" "nosql-mongodb-command" "nosql-mongodb-document" "nosql-mongodb-query" "action-naming-laravel53" "nosql-mongodb-execute-query" "nosql-mongodb-execute-bulkwrite"; do
	echo ""
	echo "check ${name}..."
	err_count=0
	for count in {1..3}; do
		echo "" > /var/log/networkbench/php-agent.log
		rm -f /docker/tmp/wget.log
		if [ ${name} == "action-naming-laravel53" ];then
			wget http://127.0.0.1/${name}/laravel-5.3/server.php -q -t 1 -O /docker/tmp/wget.log
			echo "访问的应用地址: http://127.0.0.1/${name}/laravel-5.3/server.php" >> /docker/tmp/wget.log
		else
			wget http://127.0.0.1/${name}.php -q -t 1 -O /docker/tmp/wget.log
			echo "访问的应用地址：http://127.0.0.1/${name}.php" >>/docker/tmp/wget.log
		fi
		check="TRUE"
		source /docker/script/check/${name}.sh $count ${name}
		if [[ ${check} = "TRUE" ]]; then
			echo "${name} PASSED"
			echo "${webserver}-php${php}-${ts}-${name} PASSED" >> /docker/log/verify.log
		else
			((err_count++))
			echo -e "\033[31m ${name} FAIL: ${check} \033[0m"
			logname="/docker/log/${webserver}-php${php}-${ts}-php-agent-${name}.html"
			cat /var/log/networkbench/php-agent.log >> ${logname}
			echo "${webserver}-php${php}-${ts}-${name} FAIL: ${check}, see agent detail in ${logname}" >> /docker/log/verify.log
			wgetname="/docker/log/${webserver}-php${php}-${ts}-wget-${name}.html"
			cat /docker/tmp/wget.log >> ${wgetname}
			echo "see wget detail in ${wgetname}" >> /docker/log/verify.log
		fi
			if [ $count -eq 3 ]
			then
				echo -e "\e[1;32mphp version 7.0 error is $err_count\e[0m"
			fi
	done
	if [ $err_count -gt 0 ] 
		then
			((FailedNum++))
			echo "<tr class='failed'><td>${name}验证</td><td>${check}验证</td><td>失败</td><td style='width:100%;word-wrap:break-word;'>${check}失败，更多信息请点击<br><a href=${webserver}-php${php}-${ts}-php-agent-${name}.html target=framel>错误信息</a><br><a href=${webserver}-php${php}-${ts}-wget-${name}.html target=framel>访问信息</a></td></tr>" >>/docker/log/index.html
		else
			((PassNum++))
			echo "<tr class='success'><td>${name}验证</td><td>${name}验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>${name}成功</td></tr>" >>/docker/log/index.html
	fi
done
fi




#echo "<tr><th>所有测试项</th><th>成功数量</th><th>失败数量</th></tr>" >>/docker/log/index.html
#AllNum=$((FailedNum+PassNum))
#echo "<td>$AllNum</td><td>$PassNum</td><td>$FailedNum</td>" >>/docker/log/index.html
