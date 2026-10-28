#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/load_env.sh" || exit 1
require_env MCRCON_PORT MCRCON_PASS GAME_STATS_TOKEN INSURGENCY_SERVER_PATH || exit 1

echo "自动重启监听中，如果游戏进程不存在会重启游戏"
proc_name=Insurgency
while true
do
    pid=`ps -ef | grep $proc_name | grep -v grep | awk '{print $2}'`
        if [ "$pid" = "" ]; then
	    echo $proc_name"进程不存在，正在重启"
	    "$CONFIG_PATH/copy_and_restart.sh"

        fi
sleep 30
done
