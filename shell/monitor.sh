#!/bin/bash
if [ $# -lt 3 ]
        then
        echo "please input process name and interval time(second) and continue number"
        exit
fi
process=$1
dtime=$3
##1 is 3 second
interval=$2 #因为延迟，所以1s实际为3秒的间隔
path="/opt/css/tmp/"
memFile="/opt/css/tmp/mem.txt" #清空内存、cpu存放文件
cpuFile="/opt/css/tmp/cpu.txt"
memlastFile="/opt/css/tmp/finalmem.txt"
cpulastFile="/opt/css/tmp/finalcpu.txt"
rm -rf $path/*
if [ ! -x $path ]
then
mkdir $path
fi
rownum=`ps aux | grep $process|grep -v 'grep'|wc -l` #查询httpd进程的个数，如果=0则提示httpd进程不存在
if [ $rownum -eq 0 ]
        then
        echo "http process is not exist"
        exit
fi
echo "Run total num is $dtime" #输出运行总次数为dtime
for ((e=1;e<=$dtime;e++))
do
        echo "Now running is $e" #输出当前运行次数

        #get cpu data
        sum=0
        #array=($(ps aux | grep $process|egrep -v 'grep'|awk '{print $3}')) #将所有httpd进程的cpu占用百分比存放到array数组中并计算总和，保留一位小数，重定向至cpu.txt
        array=($(top -n 1 >/tmp/top.txt;grep $process /tmp/top.txt |awk '{cpu=NF-4} {print $cpu}')) #将所有httpd进程的cpu占用百分比存放到array数组中并计算总和，保留一位小数，重定向至cpu.txt
        for i in "${array[@]}"
                do
                sum=`echo "scale=1;$i+$sum"|bc`
        done
        echo $sum >>$cpuFile

        #get mem data
        sum=0
        array=($(top -n 1 >/tmp/top.txt;grep $process /tmp/top.txt |awk '{mem=NF-3} {print $mem}'))
        #array=($(ps aux | grep $process|egrep -v 'grep'|awk '{print $4}')) #将所有httpd进程的内存占用百分比存放到array数组中并计算总和，保留一位小数，重定向至tmp/mem.txt
        for i in "${array[@]}"
                do
                sum=`echo "scale=1;$i+$sum"|bc`
        done
        echo $sum >>$memFile

        sleep $interval
done
        tmpmem=`cat /proc/meminfo |grep MemTotal|awk '{print $2}'` #计算系统总的内存量单位:KB 
        memtotle=$(($tmpmem/1024)) #将系统内存转换为：MB
        for mems in `cat $memFile` #将tmp/mem.txt中的内存百分比转换为小数，然后乘以内存总量转换为MB保存到root/mem.txt中
                do
                percent=`echo "scale=3;$mems/100"|bc`
		#用每次的小数百分比乘以内存总量得到实际内存大小
                echo "$percent * $memtotle"|bc >> $memlastFile
        done
        echo "mem transfer is OK! filepath:$memlastFile"
        
		#获取核数
		core=`cat /proc/cpuinfo| grep "processor"| wc -l` #计算系统的核数
		for cpus in `cat $cpuFile` #将tmp/cpu.txt中的cpu占用率除以核数保存到root/mem.txt中
                do
                cpulast=`echo "scale=2;$cpus/$core"|bc`
		#单核cpu占用百分比
                echo $cpulast >> $cpulastFile
        done
        echo "cpu transfer is OK! filepath:$cpulastFile"
