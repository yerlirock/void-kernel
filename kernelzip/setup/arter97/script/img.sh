#!/tmp/arter97/busybox sh

cd /tmp/
/tmp/arter97/busybox rm -rf /data/media/0/.arter97
/tmp/arter97/busybox mkdir -p /data/media/0/.arter97
/tmp/arter97/busybox chown media_rw:media_rw /data/media/0/.arter97
/tmp/arter97/busybox chmod 777 /data/media/0/.arter97
/tmp/arter97/busybox touch /data/media/0/.arter97/shared
/tmp/arter97/busybox chown media_rw:media_rw /data/media/0/.arter97/shared
/tmp/arter97/busybox chmod 777 /data/media/0/.arter97/shared
/tmp/arter97/busybox unxz -c /tmp/img.tar.xz | /tmp/arter97/busybox tar -xOf - "$@" | /tmp/arter97/busybox dd of=/dev/block/mmcblk0p5
