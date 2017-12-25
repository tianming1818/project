#!/bin/bash

##提示用此脚本需要加上要测试的php agent的版本号
if [ $# -lt 1 ]
	then
	echo "please input PHP agent version Usage:  $0 1.1.0"
	exit
fi

CASE=0
curr_ver=$1
platform=`uname -i`

##定义agent path
AgentPath=/SpyTest/PHP/Compatibility/PHP_Runtime/Agent/$1/debug/

##定义要安装php agent package的命令
	INSTALCMD(){
	os=($(cat /etc/issue|head -1))
	ostype=${os[0]}
	if [ $ostype == 'Ubuntu' ]
		then
		dpkg -i tingyun-agent-php-$curr_ver.$platform.deb
	elif [ $ostype == 'CentOS' ]
		then
		rpm -ivh "tingyun-agent-php-$curr_ver.$platform.rpm"
	elif [ $ostype == 'Red' ]
		then
		#rpm -ivh "tingyun-agent-php-$curr_ver.$platform.rpm"
		/SpyTest/PHP/Compatibility/install_bin.exp install $curr_ver
	fi
}

##定义检查agent包是否存在命令
        os=($(cat /etc/issue|head -1))
        ostype=${os[0]}
        if [ $ostype == 'Ubuntu' ]
                then
                CheckAgent=`dpkg -l|grep tingyun|wc -l`
        elif [ $ostype == 'CentOS' ]
                then
		CheckAgent=`rpm -aq|grep tingyun|wc -l`
        elif [ $ostype == 'Red' ]
                then
		#CheckAgent=`rpm -aq|grep tingyun|wc -l`
		CheckAgent=`ls /usr/bin/networkbench-install.sh|wc -l`
        fi

##定义要卸载php agent package的命令
	UNLOADCMD(){
	os=($(cat /etc/issue|head -1))
        ostype=${os[0]}
        if [ $ostype == 'Ubuntu' ]
                then
		apt-get remove tingyun-agent-php -y
        elif [ $ostype == 'CentOS' ]
                then
		rpm -aq tingyun-agent-php|xargs rpm -e
        elif [ $ostype == 'Red' ]
                then
		#rpm -aq tingyun-agent-php|xargs rpm -e
		cd $AgentPath	
		./tingyun-agent-php-$curr_ver.$platform.bin uninstall
	fi

}

##定义安装php agent so的命令
	INSTALL_SO(){
        os=($(cat /etc/issue|head -1))
        ostype=${os[0]}
        if [ $ostype == 'Ubuntu' ]
                then
		/SpyTest/PHP/Compatibility/install_php.exp install
        elif [ $ostype == 'CentOS' ]
                then
		/SpyTest/PHP/Compatibility/install_php.exp install
	fi

}

##定义卸载php agent so的命令
        UNINSTALL_SO(){
        os=($(cat /etc/issue|head -1))
        ostype=${os[0]}
        if [ $ostype == 'Ubuntu' ]
                then
                /SpyTest/PHP/Compatibility/install_php.exp uninstall
        elif [ $ostype == 'CentOS' ]
                then
                /SpyTest/PHP/Compatibility/install_php.exp uninstall
        elif [ $ostype == 'Red' ]
                then
		/SpyTest/PHP/Compatibility/install_bin.exp uninstall $curr_ver
        fi

}

##下载要测试的php agent版本
cd /SpyTest/PHP/Compatibility/PHP_Runtime/Agent/
if [ -d /SpyTest/PHP/Compatibility/PHP_Runtime/Agent/$1 ]
	then
	rm -rf /SpyTest/PHP/Compatibility/PHP_Runtime/Agent/$1
fi
svn export --username tianming --password nBstianming20150309 https://192.168.1.42/nbs-newlens-agent-release/trunk/php/$1
if [ $? -ne 0 ]
	then
	echo "SVN UP ERROR"
	exit
fi



	
##定义判断web进程的命令
os=($(cat /etc/issue|head -1))
ostype=${os[0]}
if [ $ostype == 'Ubuntu' ] && [ ! -f /SpyTest/PHP/Compatibility/PHP_Runtime/PHP/sbin/php-fpm ]
	then
	CheckWEB=`ps -ef|grep apache2|grep -v grep|wc -l`
elif [ $ostype == 'Ubuntu' ]
        then
	CheckWEB=`ps -ef|grep php-fpm|grep -v grep|wc -l`
elif [ $ostype == 'CentOS' ]
        then
	CheckWEB=`ps -ef|grep httpd|grep -v grep|wc -l`
elif [ $ostype == 'Red' ]
        then
	CheckWEB=`ps -ef|grep httpd|grep -v grep|wc -l`
fi

##定义重启web服务的命令
        RestartWEB(){
        os=($(cat /etc/issue|head -1))
        ostype=${os[0]}
        if [ $ostype == 'Ubuntu' ] && [ ! -f /SpyTest/PHP/Compatibility/PHP_Runtime/PHP/sbin/php-fpm ]
		then
		/etc/init.d/apache2 stop
		/etc/init.d/apache2 start
        elif [ $ostype == 'Ubuntu' ]
                then
		pidof php-fpm|xargs kill
 		/SpyTest/PHP/Compatibility/PHP_Runtime/PHP/sbin/php-fpm
        elif [ $ostype == 'CentOS' ]
                then
		/etc/init.d/httpd stop
		/etc/init.d/httpd start
        elif [ $ostype == 'Red' ]
                then
		/etc/init.d/httpd stop
		/etc/init.d/httpd start
        fi

}

# update php agent packages
echo "Enter PHP Agent directory"
cd "$AgentPath"

# update php agent
echo -e "\e[1;32m****************  1  CASE  if PHP Agent exist to uninstall***************\e[0m"
if [ $CheckAgent -ge 1 ]
	then
	#/SpyTest/PHP/Compatibility/install_php.exp uninstall
	UNINSTALL_SO
	UNLOADCMD
	echo -e "\e[1;31m 1  CASE failed PHP Agent exist,last test is not uninstall\e[0m"
else
	((CASE++))
fi


echo -e "\e[1;32m***********************  2 CASE: Install PHP Agent back*********************\e[0m"
INSTALCMD
if [ $? -eq 0 ]
	then
	((CASE++))
else
	echo -e "\e[1;31m 2 CASE Install PHP Agent back is failed \e[0m"
	exit
fi


echo -e "\e[1;32m***********************  3 CASE: Install PHP Agent*********************\e[0m"
#/SpyTest/PHP/Compatibility/install_php.exp install
INSTALL_SO
if [ $? -eq 0 ]
	then
	((CASE++))
else
	echo -e "\e[1;31m 3 CASE Install PHP Agent failed \e[0m"
	exit
fi
##modify agent setup file log_level and open audit_mode
sed -i 's@nbs.agent_log_level = "info"@nbs.agent_log_level = "debug"@' /etc/php.d/networkbench.ini 
sed -i 's@nbs.daemon_log_level = "info"@nbs.daemon_log_level = "debug"@' /etc/php.d/networkbench.ini
sed -i 's@nbs.audit_mode = false@nbs.audit_mode = true@' /etc/php.d/networkbench.ini
sed -i 's@nbs.app_name=.*$@nbs.app_name="fvt_test_php"@' /etc/php.d/networkbench.ini
sed -i 's@nbs.license_key =.*$@nbs.license_key = "999-999-999"@' /etc/php.d/networkbench.ini



echo -e "\e[1;32m***********************  4 CASE: Check web server restart status*********************\e[0m"

RestartWEB
sleep 1
if [ $CheckWEB -gt 2 ]
    then
    ((CASE++))
else
    echo -e "\e[1;31m 4 CASE web server restart filed\e[0m"
    exit
fi
echo -e "\e[1;32m************************  5 CASE: Check agent install status*********************\e[0m"
if [ `php -i|grep networkbench|wc -l` -gt 2 ]
    then
    ((CASE++))
    else
    echo -e "\e[1;31m 5 CASE php info load networkbench filed\e[0m"
    exit
fi

echo -e "\e[1;32m***********  6 CASE: Check agent networkbench.ini nbs.agent_log_level************\e[0m"
AgentLevelValue='debug'
arrayTmp=($(curl http://127.0.0.1/info.php|grep 'nbs.agent_log_level'|head -1))
infoValue=`echo ${arrayTmp[3]}|awk -F'>' '{print $2}'`
if [ "$AgentLevelValue" == "$infoValue" ]
	then
	((CASE++))
else
	echo -e "\e[1;31m 6 CASE Check  nbs.agent_log_level failed \e[0m"
	exit
fi

echo -e "\e[1;32m***********  7 CASE: Check agent networkbench.ini nbs.daemon_log_level************\e[0m"
DaemonLevelValue='debug'
daemonTmp=($(curl http://127.0.0.1/info.php|grep 'nbs.daemon_log_level'|head -1))
infoValue2=`echo ${daemonTmp[3]}|awk -F'>' '{print $2}'`
if [ $DaemonLevelValue == $infoValue2 ]
	then
	((CASE++))
else
	echo -e "\e[1;31m7 CASE Check  nbs.daemon_log_level failed \e[0m"
	exit
fi

echo -e "\e[1;32m***********  8 CASE: Check agent networkbench.ini nbs.app_name**************\e[0m"
AppNameValue="fvt_test_php"
ANameTmp=($(curl http://127.0.0.1/info.php|grep 'nbs.app_name'|head -1))
infoValue3=`echo ${ANameTmp[3]}|awk -F'>' '{print $2}'`
if [ $AppNameValue == $infoValue3 ]
	then
	((CASE++))
else
	echo -e "\e[1;31m 8 CASE Check nbs.app_name failed  \e[0m"
	exit
fi


echo -e "\e[1;32m***********  9 CASE: Check agent networkbench.ini nbs.license_key************\e[0m"
LicenseValue="999-999-999"
licenseTmp=($(curl http://127.0.0.1/info.php|grep 'nbs.license_key'|head -1))
infoValue4=`echo ${licenseTmp[3]}|awk -F'>' '{print $2}'`
if [ $LicenseValue == $infoValue4 ]
	then
	((CASE++))
else
	echo -e "\e[1;31m 9 CASE Check nbs.app_name failed \e[0m"
	exit
fi


##卸载php agent 并且重启web server

#/SpyTest/PHP/Compatibility/install_php.exp uninstall
UNINSTALL_SO
UNLOADCMD
pidof networkbench|xargs kill
RestartWEB

echo -e "\e[1;32m ********************  10 CASE Check agent uninstall*********************\e[0m"
if [ `ps -ef|grep networkbench|grep -v grep|wc -l` -ge 1 ]
    then
    echo -e "\e[1;31m php agent uninstall failed\e[0m" 
    exit
else
    ((CASE++))
fi

echo "SUCCESS CASE is $CASE"
