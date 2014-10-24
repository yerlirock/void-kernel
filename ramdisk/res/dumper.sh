#!/res/busybox sh

export PATH=/res/asset:$PATH

if cat /proc/last_kmsg | grep -q "Kernel panic"; then
	time=0
	until ping -c 1 8.8.8.8
	do
		sleep 1
		if [[ $time == "180" ]]; then
			return 1
		fi
		time=$(($time + 1))
	done
	cat /proc/last_kmsg > /dev/last_kmsg_tmp
	ftpput -u ftp_odroid -p develoid arter97.iptime.org panic_$(date +%s).log /dev/last_kmsg_tmp
	rm /dev/last_kmsg_tmp
	dmesg -c
	sync
fi
