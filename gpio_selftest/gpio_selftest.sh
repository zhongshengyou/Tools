#!/system/bin/sh

# 定义两组gpio  两两互检
group1=(152 154 156 133 131 137 23 139 130 119 124 113 32 51 55 43 57 50 10 27 24 114 97 108 106 99 104 105 110 49 52)
group2=(153 155 157 138 132 136 20 141 140 125 122 109 33 60 53 61 56 4 8 21 22 115 96 107 100 98 103 101 102 48 45)

io_group1=1
io_group2=2

sh_file=$0
# echo "running gpio_selftest sh name: ${sh_file}"
io_group=$1
# echo "first para = $io_group"
val=$2 # 0:pull down  1:pull up
# echo "sencond para = $val"

# set GPIO4D4/GPIO4D5 to gpio mode
io -4 0xFD5F809C 0x00110000
# set GPIO0A4 to gpio mode
io -4 0xFD5F0004 0x00010000
# set GPIO0B2 to gpio mode
io -4 0xFD5F0008 0x01001010
# set GPIO4_D0/GPIO4_D1/GPIO4_D2/GPIO4_D3 to gpio mode
io -4 0xFD5F8098 0x11110000
echo " "
if [ $io_group -eq $io_group1 ]
then
    echo "group1 is used as output port"
	echo "${group1[@]}"
    for num in ${group1[@]}
    do
	   #echo "$num"
       echo $num > /sys/class/gpio/export
	   echo out > /sys/class/gpio/gpio$num/direction
	   echo $val > /sys/class/gpio/gpio$num/value
    done
	echo "=============================================================================================================="
	echo "group2 is userd as input port"
	for num in ${group2[@]}
    do
       echo $num > /sys/class/gpio/export
	   echo in > /sys/class/gpio/gpio$num/direction
	   #cat /sys/class/gpio/gpio$num/value
	   group2_list+=$(cat /sys/class/gpio/gpio$num/value)
    done
	echo "$group2_list"
elif [ $io_group -eq $io_group2 ]
then
	echo "group2 is used as output port"
	echo "${group2[@]}"
    for num in ${group2[@]}
	do
		echo $num > /sys/class/gpio/export
		echo out > /sys/class/gpio/gpio$num/direction
		echo $val > /sys/class/gpio/gpio$num/value
	done
	echo "=============================================================================================================="
	echo "group1 is used as input port"
	for num in ${group1[@]}
	do
       echo $num > /sys/class/gpio/export
	   echo in > /sys/class/gpio/gpio$num/direction
	   #cat /sys/class/gpio/gpio$num/value
	   group1_list+=$(cat /sys/class/gpio/gpio$num/value)
	done
	echo "$group1_list"
else
	echo "input para error"
fi