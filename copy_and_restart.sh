#!/usr/bin/env bash
# 脚本功能：将配置文件复制到实际目录，并且重启游戏

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/load_env.sh" || exit 1
require_env MCRCON_PORT MCRCON_PASS GAME_STATS_TOKEN INSURGENCY_SERVER_PATH || exit 1
cd "$CONFIG_PATH" || exit 1

copy_file() {
    echo "正在替换文件..."

    mkdir -p "$INSURGENCY_SERVER_PATH/Insurgency/Config/Server" \
        "$INSURGENCY_SERVER_PATH/Insurgency/Saved/Config/LinuxServer" || return 1
    startup_path="$INSURGENCY_SERVER_PATH/startup.sh"
    game_path="$INSURGENCY_SERVER_PATH/Insurgency/Saved/Config/LinuxServer/Game.ini"
    engine_path="$INSURGENCY_SERVER_PATH/Insurgency/Saved/Config/LinuxServer/Engine.ini"
    admins_path="$INSURGENCY_SERVER_PATH/Insurgency/Config/Server/Admins.txt"
    map_cycle_path="$INSURGENCY_SERVER_PATH/Insurgency/Config/Server/MapCycle.txt"
    motd_path="$INSURGENCY_SERVER_PATH/Insurgency/Config/Server/Motd.txt"

    # 将配置和 .env 复制到游戏目录，启动脚本在运行时读取凭据。
    cp "$CONFIG_PATH/startup.sh" "$startup_path" || return 1
    cp "$CONFIG_PATH/load_env.sh" "$INSURGENCY_SERVER_PATH/load_env.sh" || return 1
    install -m 600 "$ENV_FILE" "$INSURGENCY_SERVER_PATH/.env" || return 1
    cp "$CONFIG_PATH/Game.ini" "$game_path" || return 1
    chmod 600 "$game_path" || return 1
    cp "$CONFIG_PATH/Engine.ini" "$engine_path" || return 1
    cp "$CONFIG_PATH/Admins.txt" "$admins_path" || return 1
    cp "$CONFIG_PATH/MapCycle.txt" "$map_cycle_path" || return 1
    cp "$CONFIG_PATH/Motd.txt" "$motd_path" || return 1

    # 转义 sed 替换表达式中的特殊字符，保留密码原值。
    escaped_rcon_pass=$(printf '%s' "$MCRCON_PASS" | sed 's/[\\&#]/\\&/g')
    escaped_rcon_port=$(printf '%s' "$MCRCON_PORT" | sed 's/[\\&#]/\\&/g')
    sed -i "s#MCRCON_PASS_PLACE_HOLDER#${escaped_rcon_pass}#g" "$game_path" || return 1
    sed -i "s#MCRCON_PORT_PLACE_HOLDER#${escaped_rcon_port}#g" "$game_path" || return 1

    echo "替换完成"
}

kill_process_by_keyword() {
    local pids
    pids=$(ps -ef | grep "$1" | awk '$0 !~/grep/ {print $2}')
    if [ -n "$pids" ]; then
        kill -9 $pids
    fi
}

init() {
    is_inited=$(tmux ls | grep process)
    if [ "$is_inited" = "" ]; then
        echo "创建tmux窗口"
        tmux &
        tmux new -s game -d
        tmux new -s process -d

        echo "启动自动重启游戏脚本"
        printf -v listener_command 'cd %q && ./listen_process.sh' "$CONFIG_PATH"
        tmux send -t process "$listener_command" ENTER
    fi
}

if [ -f restart.lock ]; then
    echo "请先删除restart.lock"
    exit 1
fi

init

touch restart.lock

date "+%Y-%m-%d %H:%M:%S" >> "$INSURGENCY_SERVER_PATH/restart.log"

echo "正在结束Insurgency进程..."
kill_process_by_keyword "Insurgency"
sleep 6

if ! copy_file; then
    rm -f restart.lock
    exit 1
fi

sleep 1
echo "正在启动Insurgency进程..."
if [ ! -x "$INSURGENCY_SERVER_PATH/startup.sh" ]; then
    chmod +x "$INSURGENCY_SERVER_PATH/startup.sh" || { rm -f restart.lock; exit 1; }
fi
printf -v startup_command 'cd %q && ./startup.sh' "$INSURGENCY_SERVER_PATH"
tmux send -t game "$startup_command" ENTER

echo "重启完毕！"

rm -f restart.lock
