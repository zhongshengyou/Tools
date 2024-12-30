while true
do
#       am start com.antutu.benchmark.full/com.example.benchmark.full.UnityPlayerActivity
#       sleep 180
#       am force-stop com.antutu.benchmark.full
        am start com.antutu.benchmark.full/com.example.benchmark.full.RefineryActivity
        sleep 60
        am force-stop com.antutu.benchmark.full
	cat /proc/rk_dmabuf/dev | wc -l
done

