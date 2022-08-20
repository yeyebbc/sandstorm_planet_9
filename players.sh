# mcrcon 放到/usr/bin 就可以全局任意位置执行
# sudo mv mcrcon /usr/bin/
format_convert(){
    count=0
    str="Name Score NetID IP\n"
    array=(${contents//|/ })
    for(( i=0;i<${#array[@]};i++)) do
        if [[ ${array[i]} =~ "SteamNWI" ]];then
            name=${array[i-1]} 
            id=${array[i]} 
            ip=${array[i+1]}
            score=${array[i+2]}
            str=$str"$name $score $id $ip\n"
            let count=count+1
        fi
    done

    echo -e "在线玩家数:$count\n"
    echo -e $str | column -t -s' '

}




contents=`mcrcon -H $SERVER_HOST -P $MCRCON_PORT -p $MCRCON_PASS listplayers`
format_convert $contents

