#!/res/busybox sh

export PATH=/res/asset:$PATH

if [[ $@ == "1" ]]; then
	return 1
fi

if [[ $(cat /data/.arter97/vnswap) == "1" ]]; then
	/sbin/sswap -s
fi
