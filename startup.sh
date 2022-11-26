map_str="Bab,Bab|Ministry,Ministry|Citadel,Citadel|Crossing,Canyon|Farmhouse,Farmhouse|Gap,Gap|Hideout,Town|Hillside,Sinjar|Outskirts,Compound|Precinct,Precinct|Refinery,Oilfield|Summit,Mountain|PowerPlant,PowerPlant|Tell,Tell|Tideway,Buhriz|Prison,Prison"
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

Insurgency/Binaries/Linux/InsurgencyServer-Linux-Shipping ${final_map}?Game=CheckpointHardcore?MaxPlayers=12 -Port=8001 -QueryPort=8003 -hostname="[第九行星]YeYe 三服 地狱1.1 12VS40" -log -LogCmds="LogGameplayEvents Log" -GameStatsToken=53F414E2C6EF40288470CE230BC4FC8A -NoEAC -mutators=ImprovedAI,SlowCaptureTimes,Vampirism
