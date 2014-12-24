#!/res/busybox sh

export PATH=/res/asset:$PATH

if [ -e /arter97/data ]; then
	return 0
fi

if [[ $(md5sum /system/lib/egl/libGLESv2_mali.so | awk '{print $1}') != $(md5sum /data/arter97_secondrom/system/lib/egl/libGLESv2_mali.so | awk '{print $1}') ]]; then
	cp -p /system/lib/egl/libGLESv2_mali.so /data/arter97_secondrom/system/lib/egl/libGLESv2_mali.so
	chown 0.0 /data/arter97_secondrom/system/lib/egl/libGLESv2_mali.so
	chmod 644 /data/arter97_secondrom/system/lib/egl/libGLESv2_mali.so
fi

if [[ $(md5sum /system/lib/egl/libGLESv1_CM_mali.so | awk '{print $1}') != $(md5sum /data/arter97_secondrom/system/lib/egl/libGLESv1_CM_mali.so | awk '{print $1}') ]]; then
	cp -p /system/lib/egl/libGLESv1_CM_mali.so /data/arter97_secondrom/system/lib/egl/libGLESv1_CM_mali.so
	chown 0.0 /data/arter97_secondrom/system/lib/egl/libGLESv1_CM_mali.so
	chmod 644 /data/arter97_secondrom/system/lib/egl/libGLESv1_CM_mali.so
fi

if [[ $(md5sum /system/lib/egl/libEGL_mali.so | awk '{print $1}') != $(md5sum /data/arter97_secondrom/system/lib/egl/libEGL_mali.so | awk '{print $1}') ]]; then
	cp -p /system/lib/egl/libEGL_mali.so /data/arter97_secondrom/system/lib/egl/libEGL_mali.so
	chown 0.0 /data/arter97_secondrom/system/lib/egl/libEGL_mali.so
	chmod 644 /data/arter97_secondrom/system/lib/egl/libEGL_mali.so
fi

if [[ $(md5sum /system/lib/libMali.so | awk '{print $1}') != $(md5sum /data/arter97_secondrom/system/lib/libMali.so | awk '{print $1}') ]]; then
	cp -p /system/lib/libMali.so /data/arter97_secondrom/system/lib/libMali.so
	chown 0.0 /data/arter97_secondrom/system/lib/libMali.so
	chmod 644 /data/arter97_secondrom/system/lib/libMali.so
fi

if [[ $(md5sum /system/lib/libUMP.so | awk '{print $1}') != $(md5sum /data/arter97_secondrom/system/lib/libUMP.so | awk '{print $1}') ]]; then
	cp -p /system/lib/libUMP.so /data/arter97_secondrom/system/lib/libUMP.so
	chown 0.0 /data/arter97_secondrom/system/lib/libUMP.so
	chmod 644 /data/arter97_secondrom/system/lib/libUMP.so
fi
