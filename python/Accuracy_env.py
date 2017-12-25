#!/usr/bin/env python

import os,sys,json,time
import requests


#######Get LogData 
print "(@_@) kill networkbench daemon"
os.system('pidof networkbench|xargs kill >/dev/null 2>&1')
os.system('pidof networkbench|xargs kill -9 >/dev/null 2>&1')
print "(@_@) kill clear networkbench log"
os.system('>/var/log/networkbench/daemon.log')
print "(@_@) Restart agent daemon"
os.system('/etc/init.d/httpd restart >/dev/null 2>&1')
time.sleep(3) 
print "(@_@) Request local info.php"
r=requests.get('http://127.0.0.1/info.php')
print "(@_@) Waiting 10 second"
time.sleep(10)
print "(@_@) Read daemon.log local environment"
log=os.popen('grep language /var/log/networkbench/daemon.log').read()
Log=eval(log)

def PartEnv(data):
        for x,y in Log.items():
                if x==data:
                        #print y
                        return y
print "(@_@) get agent log language info"
LogData_LG=PartEnv('language')
print "(@_@) get agent log appName info"
LogData_Name=str(PartEnv("appName")).split("'")[1]
print "(@_@) get agent log host info"
LogData_HOST=PartEnv('host')
print "(@_@) get agent log agentVersion info"
LogData_Aver=PartEnv('agentVersion')
print "(@_@) get agent log ENV info"
ENV=Log['env']
def localenv(data):
        for x,y in ENV.items():
                if x==data:
                        return y
print "(@_@) get agent log Apache MPM work mode info"
LogData_ApacheMPM=localenv('Apache MPM')
print "(@_@) get agent log CPU Processors number info"
LogData_Processors=localenv('Processors')

print "(@_@) get agent log Server API info"
LogData_ServerAPI=localenv('Server API')

print "(@_@) Get agent log PHP Plugin List info"
LogData_PluginList=[]
PluginList=localenv('Plugin List')
PL=PluginList.split(',')
for a in PL:
  d=a.split('(')[0]
  LogData_PluginList.append(d)


print "(@_@) Get agent log networkbench info"
LogData_networkbench=localenv('networkbench')
print "(@_@) Get agent log Thread Safety info"
LogData_ThreadSafety=localenv('Thread Safety')
print "(@_@) Get agent log module info"
LogData_module=localenv('module')
print "(@_@) Get agent log PHP Version info"
LogData_PHPVersion=localenv('PHP Version')
print "(@_@) Get agent log Apache Version info"
LogData_ApacheVersion=localenv('Apache Version')


##data differ function
CASE=0
def diffdata(item,local,report):
	CASE=0
#	print "**Case %s" % item
        x=local.strip()
        y=report.strip()
        if cmp(x,y)==0:
                print "\033[32;1m PASS !! \033[0m"
		CASE+=1
		return CASE
        else:
                print "\033[31;1m Failed !! \033[0m"
		print "Expect Data is: ",local
		print "Reality Data is: ",report
		return CASE

print "(@_@) Processors diff result"
Processors=diffdata("Processors",os.popen('cat /proc/cpuinfo| grep "processor"| wc -l').read(),LogData_Processors)
print "(@_@) ApacheMPM diff result"
ApacheMPM=diffdata("ApacheMPM",os.popen("httpd -V|grep 'APACHE_MPM_DIR'|awk -F '[/]+' '{print $3}'|sed 's@.$@@'").read(),LogData_ApacheMPM)
CASE=Processors+ApacheMPM
print "(@_@) Networkbench diff result"
networkbench=diffdata("networkbench",os.popen("php -i|grep -A 2 networkbench|grep Version|awk -F\> '{print $2}'").read(),LogData_networkbench)
CASE=CASE+networkbench
print "(@_@) PHP Version diff result"
PHPVersion=diffdata("PHP Version",os.popen("php -i|grep 'PHP Version'|head -1|awk '{print $4}'").read(),LogData_PHPVersion)
CASE=CASE+PHPVersion
print "(@_@) Module diff result"
module=diffdata("module",os.popen("ls `php -i|grep 'extension_dir'|head -1|awk '{print $3}'`/networkbench.so").read(),LogData_module)
CASE=CASE+module

print "(@_@) Get local PHP Apache Version info"
OS=os.popen('cat /etc/issue|head -1').read().split()[0]
ApacheV=os.popen("apachectl -v|grep 'version'|awk -F '[:]+' '{print $2}'").read()
Local_ApacheVersion=ApacheV.replace('Unix',OS)
print "(@_@) Apache Version diff result"
ApacheVer=diffdata('Apache Version',Local_ApacheVersion,LogData_ApacheVersion)
CASE=CASE+ApacheVer


print "(@_@) Get local PHP Plugin List info"
PluginList=os.popen("php -m|grep -Ev 'PHP Modules|Zend Modules|^$'").read()
LPlist=PluginList.replace('\n',",")
Local_plugin_list=LPlist.split(',')
Local_plugin_list.pop()

##plugin_list diff result"
if len(LogData_PluginList) >= len(Local_plugin_list):
	list2=[]
	print "(@_@) Case Plugin List"
	for xlist in LogData_PluginList:
		if xlist in Local_plugin_list:
			print "\033[32;1m %s is PASS !! \033[0m" % xlist
			CASE+=1
		else:
			list2.append(xlist)
	print "\033[31;1mReport data %s is not Local list \033[0m" % list2
	r=requests.get('http://127.0.0.1/info.php')
	phpinfo=r.text
	for item_data in list2:
		if item_data in phpinfo:
			print "\033[32;1mBut %s is info.php,Pass !! \033[0m" % item_data
			CASE+=1
		else:
			print "\033[31;1mFailed !!\033[0m"
			print "Expect is %s" % item_data
			print "Report data is not exist"
	
else:
	list3=[]
	for xlist in Local_plugin_list:
		if  xlist in LogData_PluginList:
			print "\033[32;1m %s is PASS !! \033[0m" % xlist
			CASE+=1
		else:
			list3.append(xlist)
	print "\033[31;1mFailed !!\033[0m"
	print "Expect is %s" % list3
	print "Report data is not exist"


print "(@_@) Get local Thread Safety info"
TS=os.popen("php -i|grep 'Thread Safety'|awk '{print $4}'").read().strip()
if TS == "enabled":
        ThreadSafety='yes'
else:
        ThreadSafety='no'
print "(@_@) Thread Safety diff result"
ThreadSafety=diffdata("Thread Safety",ThreadSafety,LogData_ThreadSafety)
CASE=CASE+ThreadSafety

print "(@_@) Server API FPM/FastCGI diff result"
print "**Case Server API FPM/FastCGI"
Local_ServerAPI=os.popen("curl http://127.0.0.1/info.php|grep 'Server API'|head -1|awk -F '[<>]+' '{print $7}'").read()
Local_ServerAPI=Local_ServerAPI.strip()
if cmp(Local_ServerAPI,LogData_ServerAPI)==0:
	print "\033[32;1m Pass !! \033[0m"
	CASE+=1
else:
	print "\033[31;1m Failed !!\033[0m"
	print "Expect is: %s" % Local_ServerAPI
	print "Report data is: %s" % LogData_ServerAPI

print "-"*60
print "All CASE number is 49"
Failed_CASE=49-CASE
print "Success CASE is %s" % CASE
print "Failed CASE is %s" % Failed_CASE
