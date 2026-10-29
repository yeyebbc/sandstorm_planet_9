#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/load_env.sh" || exit 1
require_env MCRCON_PORT MCRCON_PASS GAME_STATS_TOKEN INSURGENCY_SERVER_PATH || exit 1

LOG_FILE="$INSURGENCY_SERVER_PATH/Insurgency/Saved/Logs/Insurgency.log"

# Steam 注册失败或连接丢失后，进程仍会运行，但服务器不会出现在浏览器中。
steam_unregistered() {
    local pid="$1" uptime last_ok last_fail

    uptime=$(ps -o etimes= -p "$pid" 2>/dev/null | tr -d ' ')
    [[ "$uptime" =~ ^[0-9]+$ ]] || return 1
    [ -f "$LOG_FILE" ] || return 1

    last_ok=$(grep -n 'OnCreateSessionComplete: PublicConnectString updated - \[' "$LOG_FILE" 2>/dev/null | tail -n 1 | cut -d: -f1)
    last_fail=$(grep -nE 'FOnlineAsyncTaskSteamCreateServer bWasSuccessful: 0|STEAM \(NWI\): Steam connection failure' "$LOG_FILE" 2>/dev/null | tail -n 1 | cut -d: -f1)

    # 最近一次 Steam 注册成功之后又出现了失败/断线。
    if [ -n "$last_fail" ] && { [ -z "$last_ok" ] || [ "$last_fail" -gt "$last_ok" ]; }; then
        return 0
    fi

    # 启动超过 60 秒仍未完成 Steam 注册（15 秒超时后不会自动重试）。
    if [ "$uptime" -gt 60 ] && [ -z "$last_ok" ] && grep -q 'Register Server (SteamNWI)' "$LOG_FILE" 2>/dev/null; then
        return 0
    fi

    return 1
}

echo "自动重启监听中，如果游戏进程不存在或 Steam 注册失败会重启游戏"
proc_name=Insurgency
while true
do
    pid=$(ps -ef | grep "$proc_name" | grep -v grep | awk '{print $2}' | head -n 1)
    if [ -z "$pid" ]; then
        echo "$proc_name进程不存在，正在重启"
        "$CONFIG_PATH/copy_and_restart.sh"
        sleep 90
        continue
    fi

    if steam_unregistered "$pid"; then
        echo "Steam 注册失败或连接已丢失，正在重启"
        "$CONFIG_PATH/copy_and_restart.sh"
        sleep 90
        continue
    fi

    sleep 30
done
