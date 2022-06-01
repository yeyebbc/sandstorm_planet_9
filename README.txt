更新配置流程
1.将本仓库git clone到自己电脑
2.这时就可以在本地修改配置文件了
3.修改完git push
4.让配置在服务器生效
	（1）登录服务器
	（2）cd config/sandstorm_planet_9
	（3）git stash
	（4）git pull
	（5）git stash pop
	（6）./copy_and_restart.sh

说明：
脚本copy_and_restart.sh作用：
将仓库下的配置文件，复制到实际的游戏目录中，并且重启游戏，可以用它来重启游戏。
