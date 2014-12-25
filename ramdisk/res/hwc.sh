#!/res/busybox sh

export PATH=/res/asset:$PATH

DATA=/data
if [ -e /arter97/data ] ; then
	DATA=/arter97/data
fi

HWC=0
if strings /system/lib/hw/hwcomposer.smdk4x12.so | grep -q libExynosHWCService.so; then
	HWC=1
fi
if strings /system/lib/hw/hwcomposer.exynos4.so | grep -q libExynosHWCService.so; then
	HWC=1
fi

if [[ $HWC == "0" ]]; then
	mount -o rw,remount /system
	cd $DATA/arter97/"$@"/lib
	find . -type f | while read file; do
		rm /system/lib/$file
		cp $file /system/lib/$file
		chown 0.0 /system/lib/$file
		chmod 644 /system/lib/$file
	done
	cp -p /system/lib/gralloc.exynos4.so /system/lib/gralloc.smdk4x12.so
	cp -p /system/lib/hwcomposer.exynos4.so /system/lib/hwcomposer.smdk4x12.so
	cp -p /system/lib/camera.exynos4.so /system/lib/camera.smdk4x12.so
	if [ ! -e /arter97/data ] ; then
		mount -o ro,remount /system
	fi
fi
