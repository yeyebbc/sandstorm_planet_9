
#!/bin/sh
echo "自动重启监听中，如果游戏进程不存在会重启游戏"
proc_name=Insurgency
while true
do
    pid=`ps -ef | grep $proc_name | grep -v grep | awk '{print $2}'`
        if [ "$pid" == "" ]; then
	    echo $proc_name"进程不存在，正在重启"
	    ./copy_and_restart.sh

        fi
sleep 30
done
