首次配置
1.在仓库目录执行 cp .env.example .env
2.编辑 .env，填写 MCRCON_PASS、GAME_STATS_TOKEN，并确认服务器地址、RCON 端口和游戏目录。
  .env 使用 Bash 语法，包含空格、$、#、& 等字符的值请用单引号包裹。
  CONFIG_PATH 默认使用 .env 所在的仓库目录，可按需设置。
3.执行 chmod 600 .env，限制配置文件的访问权限。
4.脚本会自动加载 .env；缺少文件或必需变量时会提示并退出。
  .env 已被 Git 忽略，.env.example 只保留配置模板。

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
部署时会同时复制 load_env.sh 和 .env 到游戏目录，.env 权限为 600。
startup.sh 在启动时读取 GAME_STATS_TOKEN，Game.ini 中的 RCON 配置由 .env 填充。
