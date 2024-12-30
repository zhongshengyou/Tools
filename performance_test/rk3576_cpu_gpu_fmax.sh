#!/system/bin/sh

echo 950000 > /sys/kernel/debug/regulator/vdd_cpu_big_s0/voltage
echo 950000 > /sys/kernel/debug/regulator/vdd_cpu_lit_s0/voltage
echo 850000 > /sys/kernel/debug/regulator/vdd_gpu_s0/voltage
echo performance > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
echo performance > /sys/devices/system/cpu/cpufreq/policy4/scaling_governor
echo performance  > /sys/class/devfreq/27800000.gpu/governor

echo "cpul rm=1" >  /dev/ttyFIQ0
io -4 0x2600e03c 0x001c0004
io -4 0x2600e044 0x001c0004
io -4 0x2600e038 0x00020002
sleep 0.1
io -4 0x2600e038 0x00020000

echo "cci rm=1" >  /dev/ttyFIQ0
io -4 0x26010054 0x001c0004

echo "cpub rm=1" >  /dev/ttyFIQ0
io -4 0x2600c03c 0x001c0004
io -4 0x2600c044 0x001c0004
io -4 0x2600c038 0x00020002
sleep 0.1
io -4 0x2600c038 0x00020000

echo "gpu rm=1" >  /dev/ttyFIQ0
io -4 0x2601603c 0x001c0004
io -4 0x26016040 0x001c0004
io -4 0x26016048 0x001c0004


echo "cpul pvtpll" >  /dev/ttyFIQ0
io -4 0x27260024 0x1dff0017
io -4 0x2726002c 0x18
io -4 0x27260020 0x00220022
io -4 0x27260020 0x00230023
sleep 0.1
io -4 0x27260050
sleep 0.1
io -4 0x27260054
io -4 0x27240304 0x20002000
io -4 0x27240304 0x00c00040

echo "cci pvtpll" >  /dev/ttyFIQ0
io -4 0x27250024 0x1dff006c
io -4 0x2725002c 0x18
io -4 0x27250020 0x00220022
io -4 0x27250020 0x00230023
io -4 0x27250050
sleep 0.1
io -4 0x27250054
sleep 0.1
io -4 0x27248310 0x40004000
io -4 0x27248310 0x30001000
io -4 0x27248310 0x0f800000

echo "cpub pvtpll" >  /dev/ttyFIQ0
io -4 0x27258024 0x1dff0013
io -4 0x2725802c 0x18
io -4 0x27258020 0x00220022
io -4 0x27258020 0x00230023
sleep 0.1
io -4 0x27258050
sleep 0.1
io -4 0x27258054
io -4 0x27238308 0x00200020
io -4 0x27238304 0xc0004000


echo "gpu pvtpll" >  /dev/ttyFIQ0
io -4 0x27268024 0x1dff004c
io -4 0x2726802c 0x18
io -4 0x27268020 0x00220022
io -4 0x27268020 0x00230023
sleep 0.1
io -4 0x27268050
sleep 0.1
io -4 0x27268054
io -4 0x27200594 0x02000200
io -4 0x27200594 0x01000100

echo "cpul freq:"
io -4 0x27260054
echo "cci freq:"
io -4 0x27250054
echo "cpub freq:"
io -4 0x27258054
echo "gpu freq:"
io -4 0x27268054

