#!/system/bin/sh

# 定义两组gpio  两两互检
group1=(152 154 156 133 131 137 23 139 130 119 124 113 32 51 55 43 57 50 10 27 24 114 97 108 106 99 104 105 110 49 52)
group2=(153 155 157 138 132 136 20 141 140 125 122 109 33 60 53 61 56 4 8 21 22 115 96 107 100 98 103 101 102 48 45)

con_group1=("CON1_4" "CON1_8" "CON1_12" "CON1_54" "CON1_62" "CON1_68" "CON2_71" "CON2_6" "CON2_10" "CON2_18" "CON2_26"
 "CON2_46" "CON3_1" "CON3_27" "CON3_31" "CON3_39" "CON3_51" "CON3_55" "CON3_61" "CON3_65" "CON3_69" "CON3_50" "CON3_54"
 "CON3_58" "CON3_62" "CON3_66" "CON3_70" "CON3_74" "CON3_78")
con_group2=("CON1_6" "CON1_10" "CON1_14" "CON1_56" "CON1_64" "CON1_70" "CON2_75" "CON2_8" "CON2_16" "CON2_24" "CON2_30"
 "CON3_25" "CON3_3" "CON3_29" "CON3_33" "CON3_41" "CON3_53" "CON3_59" "CON3_63" "CON3_67" "CON3_71" "CON3_53" "CON3_56"
 "CON3_60" "CON3_64" "CON3_68" "CON3_72" "CON3_76" "CON3_80")

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
	   group2_list+="$(cat /sys/class/gpio/gpio$num/value) "
    done
	echo "$group2_list"
	i=0
	for v in ${group2_list[@]}
	do
		echo "output:$val    input:$v"
		if [ $v != $val ]; then
			echo "GPIO Test Failed! Please check ${con_group1[$i]} ${con_group2[$i]} "
		fi
		i=`expr $i + 1`
	done
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
	   group1_list+="$(cat /sys/class/gpio/gpio$num/value) "
	done
	echo "$group1_list"
	i=0
	for v in ${group1_list[@]}
	do
		echo "output:$val    input:$v"
		if [ $v != $val ]; then
			echo "GPIO Test Failed! please check ${con_group2[$i]} ${con_group1[$i]} "
		fi
		i=`expr $i + 1`
	done
else
	echo "input para error"
fi