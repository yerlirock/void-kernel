#!/res/busybox sh

export PATH=/res/asset:$PATH

. /res/customconfig/init.profile
if [ -e /data/.arter97/default.profile ]; then
	. /data/.arter97/default.profile
fi

if [[ $vnswap == "on" ]]; then
	/sbin/sswap
fi
