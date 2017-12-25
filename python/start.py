#!/usr/bin/env python
#coding:utf8
import time,os,sys

work = {'help':'''This is a scripts gather,you must input parallelism param,Example:[%s 1] ---- funcation:
         1、环境准确性验证
	 2、探针的安装、卸载、配置文件修改下发验证
	 3、日志文件测试
	 4、兼容性回归测试
	 5、Action和Apdex准确性验证
''' % sys.argv[0],
	'1':'/SpyTest/PHP/Automation/AllScripts/Accuracy_env.py',	
	'2':'/SpyTest/PHP/Automation/AllScripts/Install_Remove.sh',	
	'3':'/SpyTest/PHP/Automation/AllScripts/LogFile.py',	
	'4':'/SpyTest/PHP/Automation/AllScripts/Compatibly/PHP_ComTest.sh',	
	'5':'/SpyTest/PHP/Automation/AllScripts/Accuracy_action.py',	

}
#sys.argv[0]
try:
    one=sys.argv[1]
except IndexError:
    print "you must input a param"
    one='help'

try:
    two=sys.argv[2]
except IndexError:
    pass

def check(param=''):
    if one not in work.keys():
        print "Sorry,without this option"
    else:
        print '--->',work[one],' ',param
        if one != 'help':
            os.system('%s %s' %(work[one],param))

try:
    if one == '2' or one == '4':
        check(two)
    else:
        check()  
except NameError:
    print "If you want Install Remove test or Compatibility test, please input agent version"
    exit()

