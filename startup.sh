# map_str="Bab,Bab|Ministry,Ministry|Citadel,Citadel|Crossing,Canyon|Farmhouse,Farmhouse|Gap,Gap|Hideout,Town|Hillside,Sinjar|Outskirts,Compound|Precinct,Precinct|Refinery,Oilfield|Summit,Mountain|PowerPlant,PowerPlant|Tell,Tell|Tideway,Buhriz|Prison,Prison"
# array=(${map_str//|/ })
# array_len=${#array[@]}
# rand_index=$(( $RANDOM % array_len ))
# rand_map=${array[rand_index]}

# rand_group_index=$(( $RANDOM % 2 ))
# group_array=(Insurgents Security)
# name3=${group_array[rand_group_index]}

# a=(${rand_map//,/ })
# name1=${a[0]}
# name2=${a[1]}
# final_map="${name2}?Scenario=Scenario_${name1}_Checkpoint_${name3}"
# echo "本次重启随机地图:${final_map}"


Insurgency/Binaries/Linux/InsurgencyServer-Linux-Shipping Oilfield?Scenario=Scenario_Refinery_Checkpoint_Insurgents?Lighting=Day?MaxPlayers=8 -Port=8001 -QueryPort=8003 -hostname="[第九行星] 二服 ISMC 真實動作地圖包 1.0 8VS32" -log -LogCmds="LogGameplayEvents Log" -Mods -ModList=Mods.txt ModDownloadTravelTo=Conflict?Scenario=Scenario_Conflict_Checkpoint_Insurgents?Lighting=Day?"mutators=ImprovedAI" -GameStatsToken=E83EFA9BDCD34829A8B18298C420E9BA -NoEAC -mutators=ISMCarmory_Legacy,zCore,BeyondMeat,ForceRankISMC,RealisticMovementHardcore,HealthRegen,MapVoteLabels,SlowCaptureTimes,HardcoreHUD,ThrowableMines -MapCycle
# Insurgency/Binaries/Linux/InsurgencyServer-Linux-Shipping ${final_map}?MaxPlayers=8 -Port=8001 -QueryPort=8003 -hostname="[第九行星]YeYe 模组服" -log -LogCmds="LogGameplayEvents Log" -Mods -ModList=Mods.txt ModDownloadTravelTo=Tell?Scenario=Scenario_Tell_Outpost?Lighting=Day -GameStatsToken=E83EFA9BDCD34829A8B18298C420E9BA -NoEAC -mutators=ZombiesLiteRegular,ZombiesLiteDogs,ZombiesLiteBoomers

#Insurgency/Binaries/Linux/InsurgencyServer-Linux-Shipping Tell?Scenario=Scenario_Tell_Checkpoint_Security?MaxPlayers=8 -Port=8001 -QueryPort=8003 -hostname="[第九行星]YeYe 二服 测试" -log -LogCmds="LogGameplayEvents Log" -GameStatsToken=E83EFA9BDCD34829A8B18298C420E9BA -NoEAC -mutators=ImprovedAI,NPMod,HardcoreHUD,FpLegs,SlowCaptureTimes,ThermalVision -Mods ModDownloadTravelTo=TORO?Scenario=Scenario_TORO_Checkpoint_Insurgents
