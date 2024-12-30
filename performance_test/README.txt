负载测试
测试内容：CPU/GPU/VPU/NPU高负载测试

测试步骤：
1，将performance_test.tar.gz push到机器的data目录下
adb root
adb remount
adb push performance_test.tar.gz data/

2,在机器中解压performance_test.tar.gz
adb shell
cd /data/
tar -zxvf performance_test.tar.gz
cd performance_test
cp native_mediaplayer /system/bin/
chmod 777 run_test.sh

3,运行run_test.sh
cd /data/performance_test
./run_test.sh &

