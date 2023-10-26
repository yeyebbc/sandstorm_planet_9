# 脚本功能：将配置文件复制到实际目录，并且重启游戏

# 在/etc/profile文件配置如下：
# export SERVER_HOST=服务器ip
# export MCRCON_PORT=27015
# export MCRCON_PASS=密码（随便起）
# export GAME_STATS_TOKEN=steam的token
# export CONFIG_PATH=配置目录(例如/home/steam/config/sandstorm_planet_9)
# export INSURGENCY_SERVER_PATH=沙暴服务器路径（例如/home/steam/Steam/steamapps/common/sandstorm_server）
# export SISSM_PATH=/home/steam/sissm
# 最后在命令行执行source /etc/profile，让配置生效


copy_file() {
	# 功能：将配置目录下的配置文件，复制到实际相应的目录中
	echo "正在替换文件..."

 	mkdir -p ${INSURGENCY_SERVER_PATH}/Insurgency/Config/Server
	startup_path="${INSURGENCY_SERVER_PATH}/startup.sh"
	game_path="${INSURGENCY_SERVER_PATH}/Insurgency/Saved/Config/LinuxServer/Game.ini"
	engine_path="${INSURGENCY_SERVER_PATH}/Insurgency/Saved/Config/LinuxServer/Engine.ini"

	admins_path="${INSURGENCY_SERVER_PATH}/Insurgency/Config/Server/Admins.txt"
	map_cycle_path="${INSURGENCY_SERVER_PATH}/Insurgency/Config/Server/MapCycle.txt"
	motd_path="${INSURGENCY_SERVER_PATH}/Insurgency/Config/Server/Motd.txt"


	# 将git目录文件复制到实际目录
	cp $CONFIG_PATH/startup.sh $startup_path
	cp $CONFIG_PATH/Game.ini $game_path
	cp $CONFIG_PATH/Engine.ini $engine_path
	cp $CONFIG_PATH/Admins.txt $admins_path
	cp $CONFIG_PATH/MapCycle.txt $map_cycle_path
	cp $CONFIG_PATH/Motd.txt $motd_path

	# 将占位字符替换成实际内容
	sed -i "s#MCRCON_PASS_PLACE_HOLDER#${MCRCON_PASS}#g" $game_path
	sed -i "s#MCRCON_PORT_PLACE_HOLDER#${MCRCON_PORT}#g" $game_path


	sed -i "s#GAME_STATS_TOKEN_PLACE_HOLDER#${GAME_STATS_TOKEN}#g" $INSURGENCY_SERVER_PATH/startup.sh


	echo "替换完成"
}

kill_process_by_keyword(){
	kill -9 $(ps -ef|grep $1|gawk '$0 !~/grep/ {print $2}' |tr -s '\n' ' ')
}


init(){
     is_inited=`tmux ls|grep process`
     if [ "$is_inited" == "" ]; then
	echo "创建tmux窗口"
        tmux &
        tmux new -s game -d
        tmux new -s process -d
               
 	echo "启动自动重启游戏脚本"
        tmux send -t process "cd $CONFIG_PATH;./listen_process.sh" ENTER
     fi
	
}


if [ -f restart.lock ];then
    echo "请先删除restart.lock"
    exit
fi

init

touch restart.lock

echo $(date "+%Y-%m-%d %H:%M:%S")>>$INSURGENCY_SERVER_PATH/restart.log

#echo "正在结束sissm进程..."
#kill_process_by_keyword "sissm"

echo "正在结束Insurgency进程..."
kill_process_by_keyword "Insurgency"
sleep 6


copy_file

sleep 1
echo "正在启动Insurgency进程..."
if [ ! -x  $INSURGENCY_SERVER_PATH/startup.sh ];then
    sudo chmod +x $INSURGENCY_SERVER_PATH/startup.sh
fi
tmux send -t game "cd $INSURGENCY_SERVER_PATH;./startup.sh" ENTER

#sleep 6

#echo "正在启动sissm进程..."
#if [ ! -x  $SISSM_PATH/sissm ];then
#    sudo chmod +x $SISSM_PATH/sissm
#fi
#tmux send -t sissm "cd $SISSM_PATH;./sissm sissm.cfg" ENTER

echo "重启完毕！"

rm -f restart.lock
