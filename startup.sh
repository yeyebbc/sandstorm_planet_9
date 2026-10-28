#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/load_env.sh" || exit 1
require_env GAME_STATS_TOKEN || exit 1
cd "$SCRIPT_DIR" || exit 1

map_str="Bab,Bab|Ministry,Ministry|Citadel,Citadel|Crossing,Canyon|Farmhouse,Farmhouse|Gap,Gap|Hideout,Town|Hillside,Sinjar|Outskirts,Compound|Precinct,Precinct|Refinery,Oilfield|Summit,Mountain|PowerPlant,PowerPlant|Tell,Tell|Tideway,Buhriz|Prison,Prison|LastLight,LastLight"
array=(${map_str//|/ })
array_len=${#array[@]}
rand_index=$(( $RANDOM % array_len ))
rand_map=${array[rand_index]}

rand_group_index=$(( $RANDOM % 2 ))
group_array=(Insurgents Security)
name3=${group_array[rand_group_index]}

a=(${rand_map//,/ })
name1=${a[0]}
name2=${a[1]}

final_map="${name2}?Scenario=Scenario_${name1}_Checkpoint_${name3}"
echo "本次重启随机地图:${final_map}"



Insurgency/Binaries/Linux/InsurgencyServer-Linux-Shipping "${final_map}?Game=Checkpoint?MaxPlayers=10" -Port=8001 -QueryPort=8003 -hostname="[第九行星] No.4 开局 1 点奋斗服 [1.1] 10VS50 群 561191299" -log -LogCmds="all VeryVerbose" "-GameStatsToken=${GAME_STATS_TOKEN}" -NoEAC -mutators=SlowMovement,SlowCaptureTimes,zCore,ImprovedAI
