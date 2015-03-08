#!/res/busybox sh

export PATH=/res/asset:$PATH

if [[ $(cat /data/.arter97/preloadswap) != "1" ]]; then
	/sbin/sswap -s
fi
