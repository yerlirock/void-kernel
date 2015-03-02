#!/res/busybox sh

export PATH=/res/asset:$PATH

if [[ $@ == "1" ]]; then
	return 1
fi

if [[ $(cat /data/.arter97/preloadswap) == "1" ]]; then
	rm /sbin/sswap
	mv /dev/block/mmcblk0p10 /
	mkswap /mmcblk0p10
	swapon -p 5 /mmcblk0p10
fi
