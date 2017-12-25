#!/usr/bin/env python
#coding:utf8
import random,urllib2,time,datetime,os,sys
import requests,subprocess,signal,json
url=['http://127.0.0.1/mysql_db_query.php','http://127.0.0.1/ob.php','http://127.0.0.1/pgsql.php']
down_setup = None
num = None
local_action = []
local_list = []
page_list = []
reportapdex = []
page2 = []
localapdex = []

def clean():  ##清除日志方法
        x=os.popen('>/var/log/networkbench/daemon.log')

def start_pro(progress):
        start=os.system(progress)
        if start == 0:
                pass
        else:
                print "%s start failed" % progress

def kill_pro(progress):
        p = subprocess.Popen(['ps','-A'],stdout=subprocess.PIPE)
        out,err = p.communicate()
        for line in out.splitlines():
                if progress in line:
                        pid=int(line.split()[0])
                        os.kill(pid,signal.SIGKILL)
        if not progress in line:
                pass
        else:
                print "%s kill failed" % progress
def restart_agent():
    kill_pro('networkbench')
    start_pro('/etc/init.d/httpd restart >/dev/null 2>&1')
    m=requests.get('http://127.0.0.1/info.php')
    time.sleep(5)
    #获取服务器下发日志中的apdex值
    x=os.popen('grep applicationId /var/log/networkbench/daemon.log|head -1').read()
    try:
        a=json.loads(x)
    except ValueError:
        print "please check DC-SERVER Whether or not an error?"
        exit()
    #将apdex值转化成全局变量
    # global down_setup
    down_setup=a['result']['apdex_t']
    clean()

def WaiteLog():
    while True:
        line=os.popen('cat /var/log/networkbench/daemon.log|head -1')
        data=line.read()
        if data:
            break
        else:
            continue

def access(*urls):
    local_list=[]
    local_action=[]
    for myurl in urls:
        print '===>',myurl
        list1=[]
        list2=[]
        # global num
        num=random.randint(2, 5)
        for a in range(num):
            start=time.time()
            response = urllib2.urlopen(myurl, timeout=10)
            end=time.time()
            result=end-start
            result=int(result*1000)
            list1.append(result)
        #将每次请求的数据存入一个列表中，再收集到一个大的列表中
        local_action.append(list1)
        #将所有的请求数据转换成全局变量
        # global local_action
        #收集每次请求中的性能数据
        list2.append(num)
        list2.append(sum(list1))
        list2.append(max(list1))
        list2.append(min(list1))
        list2.append(sum([i*i for i in list1]))
        print "number is %s" %num
        print "sum is %s" %sum(list1)
        print "max is %s" %max(list1)
        print "min is %s" %min(list1)
        print "sumsq is %s" %sum([i*i for i in list1])
        #将多次的性能数据收集到一个列表中
        local_list.append(list2)
    # global local_list

class report_log():
    def __init__(self):
        x=os.popen('grep perfMetrics /var/log/networkbench/daemon.log|head -1').read()
        try:
            a=json.loads(x)
            self.perf=dict(a[0])
            self.errorT=dict(a[1])
            self.actionT=dict(a[2])
            self.sqlTr=dict(a[3])
        except ValueError:
            print "please check DC-SERVER Whether or not an error?"
            exit()

    def perfmetrics(self,*urls):
        action=self.perf['actions']
        page_list=[]
        page2=[]
        action2=[]
        for url in urls:
            url=url.split('/')
            page=url.pop()
            page_list.append(page)
        for page1 in page_list:
            for action1 in action:
                if page1 in action1[0]['name']:
                    #print "page is %s,report is %s"%(page1,action1[1])
                    action2.append(action1[1])
                    self.action2=action2
                    page2.append(page1)
                    self.page2=page2

    def apdex(self,*urls):
        apdex_data=self.perf['apdex']
        page_list=[]
        reportapdex=[]
        page2=[]
        for url in urls:
            url=url.split('/')
            page=url.pop()
            page_list.append(page)
        # global page_list
        #print 'page list is',page_list
        for page1 in page_list:
            for apdex1 in apdex_data:
                if page1 in apdex1[0]['name']:
                    reportapdex.append(apdex1[1])
                    self.reportapdex=reportapdex
                    page2.append(page1)
                    self.page2=page2
        # global reportapdex
        # global page2

def local_apdex(*page_list):
    endure = down_setup * 4
    localapdex=[]
    for actions in local_action:
        satisfactions=0
        endures=0
        unendures=0
        l_apdex=[]
        for action in actions:
            if action < down_setup:
                satisfactions+=1
            elif action > down_setup and action < endure:
                endures+=1
            elif action > endure:
                unendures+=1
        l_apdex.append(satisfactions)
        l_apdex.append(endures)
        l_apdex.append(unendures)
        l_apdex.append(down_setup)
        localapdex.append(l_apdex)
    # global localapdex

def deff_action():
    for page in report.page2:
        print "page is ===> %s" %page
        print "num is %s,%s" %(local_list[report.page2.index(page)][0],report.action2[report.page2.index(page)][0])
        print "sum is %s,%s" %(local_list[report.page2.index(page)][1],report.action2[report.page2.index(page)][1])
        print "max is %s,%s" %(local_list[report.page2.index(page)][2],report.action2[report.page2.index(page)][3])
        print "min is %s,%s" %(local_list[report.page2.index(page)][3],report.action2[report.page2.index(page)][4])
        print "sumsq is %s,%s" %(local_list[report.page2.index(page)][-1],report.action2[report.page2.index(page)][-1])

#page2,reportapdex,localapdex
def diff_apdex():
    print "local action is %s" %local_action
    for a in reportapdex:
        if cmp(a,localapdex[reportapdex.index(a)]) == 0:
            print "PASS !!!,page %s report apdex is %s,local apdex is %s" %(page2[reportapdex.index(a)],localapdex[reportapdex.index(a)],a)
        else:
            print "FAILED !!!page %s report apdex is %s,local apdex is %s" %(page2[reportapdex.index(a)],localapdex[reportapdex.index(a)],a)
def output(strs):
    a=80
    lens=len(strs)
    cur=a-lens
    cur2=cur/2
    label=cur2 * "#"
    print "%s %s %s"%(label,strs,label)

if __name__ == '__main__':
    restart_agent()
    output('local action data')
    access(*url)
    WaiteLog()
    time.sleep(3)
    report=report_log()
    report.perfmetrics(*url)
    output("action data diff")
    deff_action()
    report.apdex(*url)
    local_apdex(*page_list)
    output("apdex data diff")
    diff_apdex()
