for name in  "action-naming-ci" "action-naming-yii" "action-naming-laravel" "action-naming-zend" "action-naming-cake" "action-naming-wordpress" "action-naming-drupal" "action-naming-phpwind" "action-naming-joomla" "action-naming-thinkPHP"
#for name in  "action-naming-ci" "action-naming-yii" "action-naming-laravel" "action-naming-zend" "action-naming-wordpress" "action-naming-drupal" "action-naming-phpwind" "action-naming-joomla" "action-naming-thinkPHP"
 do
	echo ""
	echo "check ${name}..."
		echo "" > /var/log/networkbench/php-agent.log
		rm -f /docker/tmp/wget.log
		if  [ -f /docker/web/${name}.php ];
			then
			wget -r --level=4 http://127.0.0.1/${name}.php -q -t 1 -O /docker/tmp/wget.log
			echo "访问的应用地址：http://127.0.0.1/${name}.php" >>/docker/tmp/wget.log	

		elif [ ${name} == "action-naming-yii" ];then						
			wget -r --level=4 "http://127.0.0.1/action-naming-yii/demos/blog/index.php" -q -t 1 -O /docker/tmp/wget.log
			echo "访问的应用地址：http://127.0.0.1/action-naming-yii/demos/blog/index.php" >>/docker/tmp/wget.log
		elif [ ${name} == 'action-naming-ci' -o ${name} == 'action-naming-cake' -o ${name} == 'action-naming-joomla' -o ${name} == 'action-naming-thinkPHP' -o ${name} == 'action-naming-drupal' -o ${name}=='action-naming-zend' -o ${name} == "action-naming-rewrite" -o ${name} == 'action-naming-laravel' ];then
			#zend框架在多个容器中正常运行需要配置cache的读写权限
			chmod 777 -R /docker/web/action-naming-zend/cache/
			wget -r --level=4 "http://127.0.0.1/${name}/index.php" -q -t 1 -O /docker/tmp/wget.log
			echo "访问的应用地址：http://127.0.0.1/${name}/index.php" >>/docker/tmp/wget.log
		elif [ ${name} == "action-naming-phpwind" ];then
			wget -r --level=4 "http://127.0.0.1/action-naming-phpwind/windframework-master/demos/helloworld/index.php" -q -t 1 -O /docker/tmp/wget.log	
			echo "访问的应用地址：http://127.0.0.1/action-naming-phpwind/windframework-master/demos/helloworld/index.php" >>/docker/tmp/wget.log
		elif [ ${name} == "action-naming-wordpress" ];then
			wget -r --level=4 "http://127.0.0.1/${name}/wp-blog-header.php" -q -t 1 -O /docker/tmp/wget.log
			echo "访问的应用地址：http://127.0.0.1/${name}/wp-blog-header.php" >>/docker/tmp/wget.log

		else
			wget -r --level=4 http://127.0.0.1/${name} -q -t 1 -O /docker/tmp/wget.log
			echo "访问的应用地址：http://127.0.0.1/${name}" >>/docker/tmp/wget.log
		fi
		sleep 1
		check="TRUE"
		source /docker/script/check/IG-${name}.sh ${name}
		if [[ ${check} = "TRUE" ]]; then
			echo "${name} PASSED"
			echo "${webserver}-php${php}-${ts}-${name} PASSED" >> /docker/log/verify.log
			((PassNum++))
			echo "<tr class='success'><td>集成测试${name}验证</td><td>${name}验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>${name}成功</td></tr>" >>/docker/log/index.html
		else
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
			((FailedNum++))
			echo "<tr class='failed'><td>集成测试${name}验证</td><td>${check}验证</td><td>失败</td><td style='width:100%;word-wrap:break-word;'>${check}失败，更多信息请点击<br><a href=${webserver}-php${php}-${ts}-php-agent-${name}.html target=framel>错误信息</a><br><a href=${webserver}-php${php}-${ts}-wget-${name}.html target=framel>访问信息</a></td></tr>" >>/docker/log/index.html
			fi
		fi

	

	sleep 1
done

#php5.4以上的版本才运行
if [[ ${php} > 5.3 ]]; then
for name in "action-naming-yii2" ;do
echo ""
	echo "check ${name}..."
#	for count in {1..3}; do
		echo "" > /var/log/networkbench/php-agent.log
		rm -f /docker/tmp/wget.log
		if  [ -f /docker/web/${name}.php ];
			then
			wget -r --level=4 http://127.0.0.1/${name}.php -q -t 1 -O /docker/tmp/wget.log
			echo "访问的应用地址：http://127.0.0.1/${name}.php" >>/docker/tmp/wget.log
		elif [ ${name} == "action-naming-yii2" ];then
			wget -r --level=4 "http://127.0.0.1/action-naming-yii2/frontend/web/index.php?r=thread/index&boardid=4" -q -t 1 -O /docker/tmp/wget.log
			echo "访问的应用地址：http://127.0.0.1/action-naming-yii2/frontend/web/index.php?r=thread/index&boardid=4" >>/docker/tmp/wget.log
		else
			wget -r --level=4 http://127.0.0.1/${name} -q -t 1 -O /docker/tmp/wget.log
			echo "访问的应用地址：http://127.0.0.1/${name}" >>/docker/tmp/wget.log
		fi
		check="TRUE"
		source /docker/script/check/IG-${name}.sh ${name}
		if [[ ${check} = "TRUE" ]]; then
			echo "${name} PASSED"
			echo "${webserver}-php${php}-${ts}-${name} PASSED" >> /docker/log/verify.log
			((PassNum++))
			echo "<tr class='success'><td>集成测试${name}验证</td><td>${name}验证</td><td>成功</td><td style='width:100%;word-wrap:break-word;'>${name}成功</td></tr>" >>/docker/log/index.html
		else
			echo -e "\033[31m ${name} FAIL: ${check} \033[0m"
			logname="/docker/log/${webserver}-php${php}-${ts}-php-agent-${name}.html"
			cat /var/log/networkbench/php-agent.log >> ${logname}
			echo "${webserver}-php${php}-${ts}-${name} FAIL: ${check}, see agent detail in ${logname}" >> /docker/log/verify.log
			wgetname="/docker/log/${webserver}-php${php}-${ts}-wget-${name}.html"
			cat /docker/tmp/wget.log >> ${wgetname}
			echo "see wget detail in ${wgetname}" >> /docker/log/verify.log
			((FailedNum++))
			echo "<tr class='failed'><td>集成测试${name}验证</td><td>${check}验证</td><td>失败</td><td style='width:100%;word-wrap:break-word;'>${check}失败，更多信息请点击<br><a href=${webserver}-php${php}-${ts}-php-agent-${name}.html target=framel>错误信息</a><br><a href=${webserver}-php${php}-${ts}-wget-${name}.html target=framel>访问信息</a></td></tr>" >>/docker/log/index.html
		fi

#	done

done
fi

