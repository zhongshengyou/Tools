#!/system/bin/sh
set -e

#视频解码路数，最多8路
DECODE_COUNT=4
#CPU负载测试进程数
CPU_COUNT=50

#chmod 777 /data/performance_test/rk3576_cpu_gpu_fmax.sh
#source /data/performance_test/rk3576_cpu_gpu_fmax.sh

#设置屏幕常亮
settings put global stay_on_while_plugged_in 3

#关掉温控
echo user_space > /sys/class/thermal/thermal_zone2/policy

#安装antutu 3d apk
pm install -r /data/performance_test/antutu_benchmark_v9_3d.apk

#npu 负载
echo performance > /sys/class/devfreq/fdab0000.npu/governor
export PATH=bin/Android/arm64-v8a:$PATH
BIN=rknn_stress_test
TOTAL_TIME=100000000
echo "mobilenet_v2_i8"
#$BIN cfg/mobilenet_v2_i8.cfg $TOTAL_TIME &
echo "\nmobilenet_v2_fp16"
#$BIN cfg/mobilenet_v2_fp16.cfg $TOTAL_TIME &
echo "\nresnet50_i8"
#$BIN cfg/resnet50_i8.cfg $TOTAL_TIME &
echo "\nresnet50_fp16"
$BIN cfg/resnet50_fp16.cfg $TOTAL_TIME &
echo "\nvgg16_max_pool_i8"
#$BIN cfg/vgg16_max_pool_i8.cfg $TOTAL_TIME &
echo "\nvgg16_max_pool_fp16"
$BIN cfg/vgg16_max_pool_fp16.cfg $TOTAL_TIME &

#编解码
for i in $(seq 1 1 $DECODE_COUNT)
do
	native_mediaplayer /data/performance_test/test.mp4 $i &
	echo "\nnative_mediaplayer $i"
done

#RGA负载
rgaImDemo -w10000000000 --copy &

#cpu负载
for i in $(seq 1 1 $CPU_COUNT)
do
	busybox yes > /dev/null &
	echo "\n start cpu load $i"
done

#gpu负载

while true
do
#	am start com.antutu.benchmark.full/com.example.benchmark.full.UnityPlayerActivity
#	sleep 180
#	am force-stop com.antutu.benchmark.full
	am start com.antutu.benchmark.full/com.example.benchmark.full.RefineryActivity
	sleep 60
	echo "temp:"
	cat /sys/class/thermal/thermal_zone*/temp
	echo "gpu/npu load:"
	cat /sys/class/devfreq/f*/load
	am force-stop com.antutu.benchmark.full
done
