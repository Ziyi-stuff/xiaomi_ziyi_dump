
#！/bin/sh
temp_max=`cat /sys/class/qcom-battery/fg_temp_max`;
time_ot=`cat /sys/class/qcom-battery/fg_time_ot`;
#echo $temp_max $time_ot
# -eq —比较两个参数是否相等
# -ne —比较两个参数是否不相等
# -lt —参数1是否小于参数2
# -le —参数1是否小于等于参数2
# -gt —参数1是否大于参数2
# -ge —参数1是否大于等于参数2
# 1.60℃~62℃+时间不超2H：正常流线
#   60℃~62℃+时间＞2H：更换电池
# 2.63℃~65℃小于10H：强制更换电池+主摄相机
# 3.66℃~85℃小于10H：强制更换电池+主摄相机、强制更换屏幕（60℃~65℃：CIT画面检测是否有烧屏，有烧屏需更换，无烧屏pass）
# 4.86℃及以上报废、以及异常温度存储10H以上报废
if [ $temp_max -gt 128 ] && [ $temp_max -le 20 ]
then
    temp_max=`cat /sys/class/qcom-battery/fg_temp_max`;
	time_ot=`cat /sys/class/qcom-battery/fg_time_ot`;
fi
msg=""
result="fail"
if [ $temp_max -gt 60 ] && [ $temp_max -le 62 ] && [ $time_ot -le 2 ]
then
    msg="Risk goods"
    result="pass"
fi
if [ $temp_max -gt 60 ] && [ $temp_max -le 63 ] && [ $time_ot -ge 2 ]
then
    msg="Replace the battery"
fi
if [ $temp_max -ge  62 ] && [ $temp_max -le 66 ] && [ $time_ot -le 10 ]
then
    msg="Replace the battery and the main camera"
fi

if [ $temp_max -ge 66 ] && [ $temp_max -le 85 ] && [ $time_ot -le 10 ]
then
    msg="Replace the battery and the main camera display screen"
fi
if  [ $temp_max -ge 85 ] || [ $time_ot -ge  10 ]
then
    msg="Scrap"
fi
if  [ $temp_max -le 60 ] && [ $time_ot -eq 0 ]
then
	result="pass"
    msg="pass"
fi
echo result=$result temp_max=$temp_max time_ot=$time_ot msg=$msg

