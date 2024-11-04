29对GPIO输入输出互检，使用脚本互检gpio
使用说明
1. adb remount
2. 把gpio_selftest.sh推到/system/bin/目录下，xxx为脚本路径
   adb push xxx\gpio_selftest.sh /system/bin
3. adb shell "gpio_selftest.sh 1 0"
   adb shell "gpio_selftest.sh 1 1"
   adb shell "gpio_selftest.sh 2 0"
   adb shell "gpio_selftest.sh 2 1"
完成gpio互检