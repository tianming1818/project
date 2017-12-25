#! /bin/bash

if [ -z "$1" ]; then
	echo "usage: out.sh version"
	exit
fi

starttime=`/usr/bin/date`
rm -rf /docker/log/*
date > /docker/log/verify.log
echo '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><title>PHP探针自动化报告</title></head><body>' >/docker/log/index.html

#"5.3" "5.4" "5.5" "5.6" "7.0" "7.1"
# for webserver in "apache" "nginx" ; do
#	 for version in "5.3" "5.4" "5.5" "5.6" "7.0" ; do
#		 for ts in  "nts" "zts" ; do

 for webserver in "apache"; do
	 for version in  "7.1" ; do
		 for ts in  "nts" ; do		
			container="${webserver}-php${version}-${ts}"
			echo '<style type="text/css">table{border:#0FF 1px solid;border-collapse:collapse;}table th{text-align:center;}table td{border:1px solid #999;text-align:center;}.success{background:#9FC;}.failed{background:#FF8888;}</style>' >>/docker/log/index.html
			echo "<table width='1000' border='0' align='center' HEIGHT='200' style='table-layout:fixed;'>" >>/docker/log/index.html
			docker start ${container}
			echo "<h1><p align='center'>环境：${container}</p></h1><h2><p align='center'>探针版本：Agent $1</p></h2>" >>/docker/log/index.html		
			docker exec -i ${container} /docker/script/inner.sh ${webserver} ${version} ${ts} $1
			docker stop -t=1 ${container} > /dev/null
		done
	done
done

#启动 mysql-dbname-port

#sleep 1
#container=mysql-dbname-port
#echo '<style type="text/css">table{border:#0FF 1px solid;border-collapse:collapse;}table th{text-align:center;}table td{border:1px solid #999;text-align:center;}.success{background:#9FC;}.failed{background:#FF8888;}</style>' >>/docker/log/index.html
#echo "<table width='1000' border='0' align='center' HEIGHT='200' style='table-layout:fixed;'>" >>/docker/log/index.html
#docker start ${container}
#echo "<h1><p align='center'>环境：${container}本地测试</p></h1><h2><p align='center'>探针版本：Agent $1</p></h2>" >>/docker/log/index.html	
#docker exec -i ${container} /docker/script/inner.sh ${webserver} ${version} ${ts} $1 ${container}
#
#docker stop -t=1 ${container}
#stoptime=`/usr/bin/date`
#echo "start time is: $starttime;"
#echo " stop time is: $stoptime";


