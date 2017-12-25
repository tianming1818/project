#!/bin/bash
if [ $# -lt 1 ]
        then
        echo "please input SO file path and function and skew"
        exit
fi

if [ $# -eq 3 ]
	then
	sofile=$1
	fun_name=$2
	skew2=$3
	
	num=`nm $sofile |grep $fun_name`
	skew=`echo $num|awk '{print $1}'|sed 's/^0*//'`
	skew1=0x$skew
	printf -v b "%#x" $[skew1+skew2]
	#echo "all skew is $b"
	addr2line -f -e $sofile $b

elif [ $# -eq 2 ]
	then
	sofile=$1
	skew2=$2
	addr2line -f -e $sofile $skew2
else
	echo "please input SO file path and function name and skew OR so file and skew"
fi

