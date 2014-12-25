#!/res/busybox sh

export PATH=/res/asset:$PATH

if [[ $@ == "1" ]]; then
	return 1
fi

if [[ $(cat /data/.arter97/vnswap) == "1" ]]; then
	echo "
# SSWAP
service swapon /sbin/sswap -s
    class core
    user root
    group root
    oneshot" >> /init.smdk4x12.rc
fi
