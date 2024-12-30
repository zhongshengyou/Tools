#!/vendor/bin/sh

#selinux need
sleep 5

mkdir -p /sdcard/pudu/log/kernel/log /sdcard/pudu/log/kernel/last_log
rm -rf /sdcard/pudu/log/kernel/last_last_log
mv /sdcard/pudu/log/kernel/last_log /sdcard/pudu/log/kernel/last_last_log
mv /sdcard/pudu/log/kernel/log /sdcard/pudu/log/kernel/last_log
mkdir -p /sdcard/pudu/log/kernel/log
#/system/bin/pkill logcat
/system/bin/logcat -v time -f /sdcard/pudu/log/kernel/log/logcat.log -n 20 -r 10240&
/system/bin/logcat -v time -b kernel -f /sdcard/pudu/log/kernel/log/kernel.log -n 10 -r 10240&
cp -rf /data/anr /sdcard/pudu/log/kernel/last_log/
cp -rf /data/tombstones /sdcard/pudu/log/kernel/last_log/
cp -rf /sys/fs/pstore /sdcard/pudu/log/kernel/last_log/

cpu_low=20
mem_low=1000000
count=0

while true
do
	# mpstat 
	cpu_info=$(/system/bin/busybox mpstat -P ALL 1 1 | /system/bin/busybox awk 'NR>11')

	time=$(date '+%m-%d %T')
	echo "\n$time count:$count\r\n$cpu_info" >> /sdcard/cpu_info.txt

	# cpu_idle=$(/system/bin/busybox mpstat -P ALL 1 1 | /system/bin/busybox awk 'NR>12 {print $11}' | xargs)
	cpu_idle=$(echo "$cpu_info" | /system/bin/busybox awk 'NR>1 {print $11}' | xargs)

	for val in ${cpu_idle[@]}
	do
		val=$(/system/bin/busybox awk -v tmp1=$val -v tmp2=$cpu_low 'BEGIN{print(tmp1<tmp2)?"0":"1"}')

		if [ $val -eq 0 ];then
			# tops=$(top -Hbq -n 1|grep pudutech |head -n 25)
			top_cpu=$(top -Hbq -n 1 | head -n 45)
			# time=$(date '+%m-%d %T')
			echo "\n$time count:$count\r\n$top_cpu" >> /sdcard/low_cpu.txt

		else
			echo "cpu_idle > $cpu_low"	
		fi
	done

	mem_info=$(free -k)
	echo "\n$time count:$count\r\n$mem_info" >> /sdcard/mem_info.txt

	mem_free=$(echo "$mem_info" | /system/bin/busybox awk 'NR==2 {print $4}')
	if (($mem_free < $mem_low))
	then
		top_mem=$(top -bs 6 -n 1 | head -n 55)
		# time=$(date '+%m-%d %T')
		echo "\n$time count:$count\r\n$top_mem" >> /sdcard/low_mem.txt
	fi

	count=`expr $count + 1`

	sleep 2
done
