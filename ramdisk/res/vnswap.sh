#!/res/busybox sh

export PATH=/res/asset:$PATH

if [[ $(cat /data/.arter97/vnswap) == "1" ]]; then
	/sbin/sswap
fi
