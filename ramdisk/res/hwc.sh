#!/res/busybox sh

export PATH=/res/asset:$PATH

DATA=/data
if [ -e /arter97/data ] ; then
	DATA=/arter97/data
fi

echo "hw/gralloc.default.so
hw/gralloc.exynos4.so
hw/gralloc.smdk4x12.so
hw/hwcomposer.exynos4.so
hw/hwcomposer.smdk4x12.so
libExynosHWCService.so
libExynosIPService.so
libfimg.so
libhdmiclient.so
libsecion.so
libsync.so" | while read file; do
	if [ ! -e /system/lib/$file ] ; then
		mount -o rw,remount /system
		touch /system/lib/$file
	fi
	if [ ! -e $DATA/arter97/"$@"/lib/$file ] ; then
		touch $DATA/arter97/"$@"/lib/$file
	fi
	if [[ $(md5sum /system/lib/$file | awk '{print $1}') != $(md5sum $DATA/arter97/"$@"/lib/$file | awk '{print $1}') ]]; then
		mount -o rw,remount /system
		cp -p $DATA/arter97/"$@"/lib/$file /system/lib/$file
		chown 0.0 /system/lib/$file
		chmod 644 /system/lib/$file
	fi
	if [ ! -e /arter97/data ] ; then
		mount -o ro,remount /system
	fi
done
