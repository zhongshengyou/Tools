#!/system/bin/sh

runCmd()
{
    $@
    ERR=$?
    printf "$* "
    if [ "${ERR}" != "0" ]; then
        echo -e "\033[47;31m [ERROR] ${ERR} \033[0m"
        exit ${ERR}
    else
        echo -e "\033[32m [OK] \033[0m"
    fi
}

function usage()
{
    echo "Usage: $0 [ARGS]"
    echo
    echo "Options:"
    echo "  -c,--counter   opt_counter=?"
    echo
    echo "  -h,--help      show this help message and exit"
    exit 1
}

function parse_args()
{
    opt_counter=3
    #[ -z "$1" ] && usage;
    GETOPT_ARGS=`busybox getopt -o c:h -al counter:,help -- "$@"`
    eval set -- "$GETOPT_ARGS"


    while [ -n "$1" ]
    do
        case "$1" in
            -c|--counter ) opt_counter=$2;  shift 2;;
            -h|--help ) usage; exit 1 ;;
            -- ) shift; break  ;;
            *  ) echo "invalid option $1"; usage; return 1 ;;
        esac
    done
}

#----------------------------------------------------------
check_ipaddr()
{
    echo $ipaddr|grep "^[0-9]\{1,3\}\.\([0-9]\{1,3\}\.\)\{2\}[0-9]\{1,3\}$" > /dev/null;
    if [ $? -ne 0 ]
    then
        #echo "IP地址必须全部为数字" 
        ret=1
        return
    fi
    local a=`echo $ipaddr|busybox awk -F . '{print $1}'`  #以"."分隔，取出每个列的值 
    local b=`echo $ipaddr|busybox awk -F . '{print $2}'`
    local c=`echo $ipaddr|busybox awk -F . '{print $3}'`
    local d=`echo $ipaddr|busybox awk -F . '{print $4}'`
    local num
    for num in $a $b $c $d
    do
        if [ $num -gt 255 ] || [ $num -lt 0 ]    #每个数值必须在0-255之间 
        then
            #echo $ipaddr "中，字段"$num"错误" 
            ret=1
            return
        fi
    done
    ret=0
}

check_wifi()
{
    local total="0"
    local i="0"

    while [ $i -lt 3 ]; do
        ipaddr=`ifconfig wlan0 | busybox awk '/inet addr/ {print $2}' | busybox awk -F: '{print $2}'`
        echo "wlan0 ip=$ipaddr"
        check_ipaddr
        if [ $ret != 0 ]; then
            total=$((total+1))
            sleep 5
        else
            total="0"
        fi
        i=$((i+1))
		sleep 1
    done

    if [ $total -ge 10 ]; then
        echo "check_ipaddr failed!"
        ret=1
    else 
        echo "check_ipaddr ok!"
        ret=0
    fi
}

wifi_on() {
    svc wifi enable
}

wifi_off() {
    svc wifi disable
}

main() {
    local counter=${opt_counter}
    local i="0"

    while [ $i -lt ${counter} ]; do
        echo ${i}
		wifi_off
        sleep 2
        wifi_on
        check_wifi
        if [ $ret != 0 ]; then
            echo "----------check_wifi ${i} times failed----------"
            return -1
        fi

        i=$((i+1))
    done

    echo "----------check_wifi ${counter} times passed----------"
}
#----------------------------------------------------------
parse_args $@
main
