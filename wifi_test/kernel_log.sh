#!/vendor/bin/sh

# open watchdog 
echo V > /dev/watchdog

# modif by zhongshengyou for can setup early fixed APP send data failed
/system/bin/ip link set can0 down
/system/bin/ip link set can0 type can bitrate 1000000 sample-point 0.76
/system/bin/ip link set can0 up

#selinux need
sleep 5

mkdir -p /sdcard/pudu/log/kernel/log /sdcard/pudu/log/kernel/last_log
rm -rf /sdcard/pudu/log/kernel/last_last_log
mv /sdcard/pudu/log/kernel/last_log /sdcard/pudu/log/kernel/last_last_log
mv /sdcard/pudu/log/kernel/log /sdcard/pudu/log/kernel/last_log
mkdir -p /sdcard/pudu/log/kernel/log
#/system/bin/pkill logcat
/system/bin/logcat -v threadtime -b main -b system -b crash -f /sdcard/pudu/log/kernel/log/logcat.log -n 20 -r 10240&
/system/bin/logcat -v threadtime -b events -f /sdcard/pudu/log/kernel/log/logcat-events.log -n 20 -r 1024&
/system/bin/logcat -v threadtime -b kernel -f /sdcard/pudu/log/kernel/log/kernel.log -n 10 -r 10240&
/system/bin/logcat -v threadtime -b radio -f /sdcard/pudu/log/kernel/log/radio.log -n 10 -r 10240&
cp -rf /data/anr /sdcard/pudu/log/kernel/last_log/
cp -rf /data/tombstones /sdcard/pudu/log/kernel/last_log/
cp -rf /sys/fs/pstore /sdcard/pudu/log/kernel/last_log/

# add by znh for display logo, set lvds backlight enable
/system/bin/cansend can0 555#d0010900000000da

check_count=0
ok_count=0
fail_count=0

while true
do
	#echo "find device"
	sleep 30
	time=$(date '+%m-%d %T')
	echo "\n$time start check!!!" >> /sdcard/wifi_test.txt
    wlan_status=$(cat /sys/class/net/wlan0/carrier)
    if [[ "$wlan_status" = "" ]]
    then
        echo "wlan0 fail" >> /sdcard/wifi_test.txt
        ((fail_count=$fail_count+1));
		break
    else
        echo "wlan0 ok" >> /sdcard/wifi_test.txt
        ((ok_count=$ok_count+1));
    fi
    ((check_count=$check_count+1));

    echo "check_count:" $check_count >> /sdcard/wifi_test.txt
    echo "ok_count:" $ok_count >> /sdcard/wifi_test.txt
    echo "fail_count" $fail_count >> /sdcard/wifi_test.txt
    sync
	sleep 1
    /system/bin/reboot

done
