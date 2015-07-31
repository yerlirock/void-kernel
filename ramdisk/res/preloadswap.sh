#!/res/busybox sh

export PATH=/res/asset:$PATH

if [[ $(cat /data/.arter97/preloadswap) == "1" ]]; then
	mkswap /dev/block/mmcblk0p10
	swapon -d[once] -p 5 /dev/block/mmcblk0p10
fi
