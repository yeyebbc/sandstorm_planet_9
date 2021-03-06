# 脚本功能：将配置文件复制到实际目录，并且重启游戏

# 在~/.profile文件配置如下：
# export MCRCON_HOST=服务器ip
# export MCRCON_PORT=27015
# export MCRCON_PASS=密码（随便起）
# export CONFIG_PATH=配置目录(例如/home/steam/config/sandstorm_planet_9)
# export INSURGENCY_SERVER_PATH=沙暴服务器路径（例如/home/steam/Steam/steamapps/common/sandstorm_server）
# export SISSM_PATH=/home/steam/sissm
# 最后在命令行执行source ~/.profile，让配置生效


copy_file() {
	# 功能：将配置目录下的配置文件，复制到实际相应的目录中
	echo "正在替换文件..."

	startup_path="${INSURGENCY_SERVER_PATH}/startup.sh"
	game_path="${INSURGENCY_SERVER_PATH}/Insurgency/Saved/Config/LinuxServer/Game.ini"
	engine_path="${INSURGENCY_SERVER_PATH}/Insurgency/Saved/Config/LinuxServer/Engine.ini"

	admins_path="${INSURGENCY_SERVER_PATH}/Insurgency/Config/Server/Admins.txt"
	map_cycle_path="${INSURGENCY_SERVER_PATH}/Insurgency/Config/Server/MapCycle.txt"
	motd_path="${INSURGENCY_SERVER_PATH}/Insurgency/Config/Server/Motd.txt"

	sissm_cfg_path="${SISSM_PATH}/sissm.cfg"

	# 将git目录文件复制到实际目录
	sudo cp $CONFIG_PATH/startup.sh $startup_path
	sudo cp $CONFIG_PATH/Game.ini $game_path
	sudo cp $CONFIG_PATH/Engine.ini $engine_path
	sudo cp $CONFIG_PATH/Admins.txt $admins_path
	sudo cp $CONFIG_PATH/MapCycle.txt $map_cycle_path
	sudo cp $CONFIG_PATH/Motd.txt $motd_path
	sudo cp $CONFIG_PATH/sissm.cfg $sissm_cfg_path

	# 将占位字符替换成实际内容
	sudo sed -i "s#MCRCON_PASS_PLACE_HOLDER#${MCRCON_PASS}#g" $game_path
	sudo sed -i "s#MCRCON_PORT_PLACE_HOLDER#${MCRCON_PORT}#g" $game_path

	sudo sed -i "s#MCRCON_PASS_PLACE_HOLDER#${MCRCON_PASS}#g" $sissm_cfg_path
	sudo sed -i "s#MCRCON_PORT_PLACE_HOLDER#${MCRCON_PORT}#g" $sissm_cfg_path
	sudo sed -i "s#SERVER_HOST_PLACE_HOLDER#${SERVER_HOST}#g" $sissm_cfg_path
	sudo sed -i "s#INSURGENCY_SERVER_PATH_PLACE_HOLDER#${INSURGENCY_SERVER_PATH}#g" $sissm_cfg_path

	sudo sed -i "s#GAME_STATS_TOKEN_PLACE_HOLDER#${GAME_STATS_TOKEN}#g" $INSURGENCY_SERVER_PATH/startup.sh


	echo "替换完成"
}

kill_process_by_keyword(){
	sudo kill -9 $(ps -ef|grep $1|gawk '$0 !~/grep/ {print $2}' |tr -s '\n' ' ')
}

echo "正在结束sissm进程..."
kill_process_by_keyword "sissm"

echo "正在结束Insurgency进程..."
kill_process_by_keyword "startup.sh"
sleep 3


copy_file

sleep 1
echo "正在启动Insurgency进程..."
sudo chmod +x $INSURGENCY_SERVER_PATH/startup.sh
screen -dm bash -c "cd $INSURGENCY_SERVER_PATH;./startup.sh"

sleep 6

echo "正在启动sissm进程..."
sudo chmod +x $SISSM_PATH/sissm
screen -dm bash -c "cd $SISSM_PATH;./sissm sissm.cfg"

echo "重启完毕！"


