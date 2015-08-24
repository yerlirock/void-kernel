#!/tmp/arter97/busybox sh

if [ -e /data/.arter97/system-cache ]; then
	/tmp/arter97/busybox rm -rf /data/.arter97
	/tmp/arter97/busybox rm -rf /data/arter97_secondrom/data/.arter97
	/tmp/arter97/busybox rm -rf /data/media/0/arter97
	/tmp/arter97/busybox mkdir /data/.arter97
	/tmp/arter97/busybox touch /data/.arter97/system-cache
else
	/tmp/arter97/busybox rm -rf /data/.arter97
	/tmp/arter97/busybox rm -rf /data/arter97_secondrom/data/.arter97
	/tmp/arter97/busybox rm -rf /data/media/0/arter97
fi
