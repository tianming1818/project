#!/usr/bin/env python
#coding:utf8

#此脚本需要在web容器中有三个php脚本页面：info.php、mysql_db_query.php、err2.php
#这三个页面可到svn中下载，地址：https://192.168.1.42/nbs-newlens-test-scripts/trunk/PHP/compatibility
import os,sys,time
import re,requests
import subprocess,signal

class Dolog:
	def clean(self):  ##清除日志方法
		print "(@_@) Clean Log Function"
		x=os.popen('>/var/log/networkbench/daemon.log')
	def kill_pro(self,progress):
	        p = subprocess.Popen(['ps','-A'],stdout=subprocess.PIPE)
	        out,err = p.communicate()
	        for line in out.splitlines():
	                if progress in line:
	                        pid=int(line.split()[0])
	                        os.kill(pid,signal.SIGKILL)
	        if not progress in line:
	                print "%s kill success" % progress
	        else:
	                print "%s kill failed" % progress
	
	def start_pro(self,progress):
	        start=os.system(progress)
	        if start == 0:
	                print "%s start success" % progress
	        else:
	                print "%s start failed" % progress

	def Grep(self,word): ##从日志中过滤指定字符，判断日志中是否有perfMetrics
		self.clean()
		print "(@_@) Access phpinfo page"
		m=requests.get('http://127.0.0.1/info.php')
		print "(@_@) sleep 65 sencond"
		time.sleep(65)
		x=os.popen('grep %s /var/log/networkbench/daemon.log' % word )
		txt=x.read()
		print "(@_@) match perfMetrics for log"
		if word=='perfMetrics':
			reg=r'"type":"(perfMetrics)","timeFrom.*$'
			relute=re.search(reg,txt).group(1)
			print "\033[32;1m Pass !!\033[0m"
			return txt
		else:
			return txt
	def sqlTraceData(self):  ##判断探针能否抓取sqlTraceData
		resu=None
		self.clean()
		print "(@_@) Access mysql page"
		url=requests.get('http://127.0.0.1/mysql_db_query.php') #调用数据库页面的请求
		print "(@_@) sleep 65 sencond"
		time.sleep(65)
		#过滤请求页面赋值给变量
		print "(@_@) match mysql page in log"
		x=os.popen("grep 'mysql_db_query.php' /var/log/networkbench/daemon.log|head -1")
		self.sql_txt=x.read() #读取变量内容
		try:
			reg=r'"sqlTraces":(\[.*?\])\].*$'
			resu=re.search(reg,self.sql_txt).group(1) #用正则匹配sqlTraces的数据
		except Exception,e:
			print "\033[31;1m PHPAgent capture the sqldata error, return is %s, Error is %s\033[0m" % (resu,e)
		else:
			print "\033[32;1m Pass !!\033[0m"
			return resu
	def actionTraceData(self): ##判断探针能否抓取actionTraceData
                resu=None
		self.clean()
		print "(@_@) Access phpinfo page"
                url=requests.get('http://127.0.0.1/info.php')
		print "(@_@) sleep 65 sencond"
                time.sleep(65)
		print "(@_@) match info page in log"
                x=os.popen("grep '/info.php' /var/log/networkbench/daemon.log|head -1")
                self.action_txt=x.read()
		print "(@_@) match sqlTraceData in log"
                try:
                        reg=r'"actionTraces":(\[.*?\])\]},\{"type":"sqlTraceData"'
                        resu=re.search(reg,self.action_txt).group(1)
                except Exception,e:
                        print "\033[31;1mPHPAgent capture the actionTraceData error, return is %s, Error is %s\033[0m" % (resu,e)
                else:
			print "\033[32;1m Pass !!\033[0m"
                        return resu	


	def errorTraceData(self):  ##判断探针能否抓取errorTraceData	
                resu=None
		self.clean()
		print "(@_@) Access error page"
                url=requests.get('http://127.0.0.1/err2.php')
		print "(@_@) sleep 65 sencond"
                time.sleep(65)
		print "(@_@) match error page in log"
                x=os.popen("grep '/err2.php' /var/log/networkbench/daemon.log|head -1")
                self.error_txt=x.read()
                try:
                        reg=r'"errorTraceData","errors":(\[.*?\])},\{"type":"actionTraceData"'
                        resu=re.search(reg,self.error_txt).group(1)
                except Exception,e:
                        print "\033[31;1mPHPAgent capture the errorTraceData error, return is %s, Error is %s\033[0m" % (resu,e)
                else:
			print "\033[32;1m Pass !!\033[0m"
                        return resu	





#test=Dolog()
#print "(@_@) perfMetrics test return"
#perf=test.Grep('perfMetrics')
#
#print "\n"
#print "(@_@) actionTraceData test return"
#action=test.actionTraceData()
#
#print "\n"
#print "(@_@) sqlTraceData test return"
#sqldata=test.sqlTraceData()
#
#print "\n"
#print "(@_@) errorTraceData test return"
#errordata=test.errorTraceData()
