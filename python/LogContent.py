#!/usr/bin/env python
#coding:utf8

import sys,time,os,requests
sys.path.append('/SpyTest/PHP/Automation/ReportData')

class loganalyse:
        def clean(self):  ##清除日志方法
                print "(@_@) Clean Log Function"
                x=os.popen('>/var/log/networkbench/daemon.log')
	##访问页面函数
	def access(self,Url):
		req=requests.get(Url)

	##重启agent函数
	def restartagent(self):
		self.clean()
		stopaget=os.popen('pidof networkbench|xargs kill').read()
		start=os.popen('/etc/init.d/httpd restart').read()
		time.sleep(5)

	##验证日志中的时间格式
	def DateFormat(self):
		print "(@_@) Test Date Format"
		self.restartagent()
		NOW=time.strftime('%Y-%m-%d %H:%M',time.localtime(time.time()))
		self.access('http://127.0.0.1/info.php')
		print "(@_@) sleep 10 sencond"
		time.sleep(20)
		print "Log date format right, Now date is %s" % NOW
		result=os.popen('grep "^%s" /var/log/networkbench/daemon.log|head -1' % NOW).read()
		print "Date format is : %s" % result
		return result
		
	##等待日志有数据输出的函数
	def WaiteLog(self):
		while True:
			line=os.popen('cat /var/log/networkbench/daemon.log|head -1')
			data=line.read()			
			if data:
				break
			else:
				continue
	##判断日志输出中的时间间隔
	def TimeInterval(self):
		print "(@_@) Test log time Interval"
		##先清空日志
		self.clean()
		##等待日志有数据输出
		self.WaiteLog()
		##日志有输出后定第一个时间点
		NOW1=time.time()
		##再清空日志，等10秒再清一次，可能一次输出的日志比较多
		self.clean()
		time.sleep(10)
		self.clean()
		##再等待日志输出
		self.WaiteLog()
		##日志有输出后再定第二个时间点
		NOW2=time.time()
		##用第二个时间点减去第一个时间点得出时间间隔
		Interval=NOW2-NOW1
		print "Log report interval time is %s second" % Interval
		return Interval
	##测试服务器下发配置
	def ServerDownSetup(self):
		print "(@_@) Test SERVER down send setup"
		self.restartagent()
		self.access('http://127.0.0.1/info.php')
		self.WaiteLog()
		time.sleep(8)
		do=os.popen("grep 'applicationId' /var/log/networkbench/daemon.log")
		self.DownSetup=do.read()
		if self.DownSetup:
			return "Server down setup success,detail look self.DownSetup" 
	##测试本地配置
	def LocalSetup(self):
		self.restartagent()
		self.access('http://127.0.0.1/info.php')
		self.WaiteLog()
		time.sleep(2)
		do=os.popen("grep 'language' /var/log/networkbench/daemon.log")
		self.localsetup=do.read()
		if self.localsetup:
			return self.localsetup
		else:
			pass
			
	##测试getRedirect
	def getRedirect(self):
		self.restartagent()	
		self.access('http://127.0.0.1/info.php')
		self.WaiteLog()
		time.sleep(2)
		redir=os.popen("grep 'getRedirectHost' /var/log/networkbench/daemon.log")
		self.redirect=redir.read()
		if self.redirect:
			return "getRedirectHost success detail look self.redirect"
	##测试Initagent
	def Initagent(self):
		self.restartagent()	
		self.access('http://127.0.0.1/info.php')
		self.WaiteLog()
		time.sleep(2)
		agent=os.popen("grep 'initAgentApp' /var/log/networkbench/daemon.log")
		self.initAgentApp=agent.read()
		if self.initAgentApp:
			return "initAgentApp success,detail look self.initAgentApp"
		

def start_test():
	test=loganalyse()
	CASE=0
	print "(@_@) DateFormat test return"
	DF=test.DateFormat()
	
	if DF:
		print "\033[32;1m Pass !!\033[0m"
		CASE+=1
	else:
		print "\033[31;1m Failed !!\033[0m"
	
	print "\n"
	print "(@_@) TimeInterval test return"
	TI=test.TimeInterval()
	if TI < 61 or TI > 59:
	        print "\033[32;1m Pass !!\033[0m"
		CASE+=1
	else:
	        print "\033[31;1m Failed !!\033[0m"
	
	print "\n"
	print "(@_@) ServerDownSetup test return"
	downsetup=test.ServerDownSetup()
	if downsetup:
		CASE+=1
	        print "\033[32;1m Pass !!\033[0m"
	else: 
	        print "\033[31;1m Failed !!\033[0m"
	
	print "\n"
	print "(@_@) LocalSetup test return"
	lsetup=test.LocalSetup()
	
	if lsetup:
		CASE+=1
	        print "\033[32;1m Pass !!\033[0m"
	else: 
	        print "\033[31;1m Failed !!\033[0m"
	
	print "\n"
	print "(@_@) getRedirect test return"
	Redirect=test.getRedirect()
	if Redirect:
		CASE+=1
	        print "\033[32;1m Pass !!\033[0m"
	else: 
	        print "\033[31;1m Failed !!\033[0m"
	
	print "\n"
	print "(@_@) Initagent test return"
	init=test.Initagent()
	if init:
		CASE+=1
	        print "\033[32;1m Pass !!\033[0m"
	else:
	        print "\033[31;1m Failed !!\033[0m"
	print "-"*60
	print "ALL CASE is 6"
	print "Success CASE is %s" % CASE
	FCASE=6-CASE
	print "Failed CASE is %s" % FCASE


start_test()
