#!/usr/bin/env python
#coding:utf8

import os,sys
import time
def Estimate_agent(file):
    if not os.path.exists(file):
        print "PHP Agent is not installed,please install agent before execution this scripts"
        exit()

Estimate_agent('/usr/bin/networkbench')

from LogContent import loganalyse
class logfile(loganalyse):
	def unixToTime(self,unixs):
		format = '%Y-%m-%d %H:%M:%S'
		value = time.localtime(unixs)
		dt = time.strftime(format, value)
		return dt
	def getfilelist(self,dir):
		dae=os.popen(dir)
                self.daemon=dae.read()
                newb=self.daemon.strip('\n')
                list1=newb.split('\n')
		return list1
	def byteToMB(self,num):
		a=num/1000
		b=a/1000
		return b
	#检查日志备份的个性
	def DaemonBackNum(self):
		list1=self.getfilelist('ls /var/log/networkbench/daemon.log.*')
		if len(list1) == 7:
			print "daemon_log back file number is 7 belong success"
		elif len(list1) > 7:
			print "daemon_log back file number is %d failed" % len(list1)
		else:
			print "daemon_log back file number is %d " % len(list1)
	#检查日志备份的大小
	def DaemonBackSize(self): 
		list2=self.getfilelist('ls /var/log/networkbench/daemon.log.*')
		list_file=[]
		for Mfile in list2:
			#把每个备份的文件大小添加到列表中
			list_file.append(self.byteToMB(os.path.getsize(Mfile)))
		print "daemon log size is : %s" % list_file
		#过滤出备份文件大小不是10M的
		for b in range(len(list_file)):
   			if list_file[b] == 10L:
				pass
   				b+=1
   			else:
   				print "%s is not 10M" % (list2[b])
   				b+=1
			
	def PhpAgentLog(self):
		list3=self.getfilelist('ls /var/log/networkbench/php-agent.log-*')
		list4=[]
		list5=[]
		for files in list3:
			#获取所有备份日志的unix时间戳
			list4.append(int(os.path.getmtime(files)))
		for files2 in list4:
			#将unix时间戳转换为正常日期格式
			list5.append(self.unixToTime(files2))
		#以下为判断备份的日志有多少份
		if len(list5) < 7:
			print "php-agent.log back file number is %d" % len(list5)
		if len(list5) == 7:
			print "php-agent.log back file number is 7,and date is %s" % list5
		if len(list5) > 7:
			print "php-agent.log back file number overstep 7,is %d, test failed" % len(list5)

if __name__=='__main__':
	log_test=logfile()
	print "(@_@) daemon log back file number: "
	log_test.DaemonBackNum()
	print "(@_@) daemon log back file size: "
	log_test.DaemonBackSize()
	print "(@_@) php-agent log back file number and size: "
	log_test.PhpAgentLog()
