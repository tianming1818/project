#! /bin/bash
	
for name in "db-pdo-mysql-dbname" "db-pdo-mysql-port" "db-mysql-port" "db-mysqli-oop-portlocal" "db-mysqli-oop-local" "db-mysqli-oop-port" "db-mysqli-conn-portlocal" "db-mysqli-conn-local" "db-mysqli-conn-port" "db-mysql-portlocal" "db-mysql-local" "db-pdo-mysql-local" "db-pdo-mysql-portlocal" "nosql-memcached-construct-socket" "nosql-mongodb-command-sock" "nosql-mongo-client-sock" "nosql-redis-socket" "db-pdo-mysql-hostlocal" "db-mysqli-oop-hostlocal" "db-mysqli-conn-hostlocal";do
	echo ""
	echo "check ${name}..."
	err_count=0
	for count in {1..3}; do
		echo "" > /var/log/networkbench/php-agent.log
		rm -f /docker/tmp/wget.log
		# if [ ${name} == 'action-naming-laravel' ]
			# then
			# wget "http://127.0.0.1/${name}/index.php" -q -t 1 -O /docker/tmp/wget.log
			# echo "访问的应用地址：http://127.0.0.1/${name}/index.php" >>/docker/tmp/wget.log
			
		# elif [ ${name} == 'nosql-memcache-oop-conn-host' -o ${name} == 'nosql-memcache-proc-conn-host' ];then
		
		    # curl -s "http://127.0.0.1/${name}.php" -o /docker/tmp/wget.log
			# echo "访问的应用地址：http://127.0.0.1/${name}.php" >>/docker/tmp/wget.log
		
		if [ ${name} == 'nosql-memcache-oop-conn-host' -o ${name} == 'nosql-memcache-proc-conn-host' ];then
			
			curl -s "http://127.0.0.1/${name}.php" -o /docker/tmp/wget.log
			echo "访问的应用地址：http://127.0.0.1/${name}.php" >>/docker/tmp/wget.log
			
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
			echo "<tr class='success'><td>${name}验证</td><td>${name}验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>${name}成功<br><a href=${webserver}-php${php}-${ts}-php-agent-${name}.html target=framel>详细信息</a><br><a href=${webserver}-php${php}-${ts}-wget-${name}.html target=framel>访问信息</a></td></tr>" >>/docker/log/index.html 
		else
			((PassNum++))
			echo "<tr class='success'><td>${name}验证</td><td>${name}验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>${name}成功</td></tr>" >>/docker/log/index.html
		fi
	fi
done


