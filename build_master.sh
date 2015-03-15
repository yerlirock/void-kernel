#!/bin/bash
if [ ! "${1}" = "skip" ] ; then
	./build_clean.sh
	./build_kernel_i9300.sh CC='$(CROSS_COMPILE)gcc' "$@"
	./build_clean.sh noimg
	./build_kernel_m440s.sh CC='$(CROSS_COMPILE)gcc' "$@"
	./build_clean.sh noimg
	./build_kernel_e210s.sh CC='$(CROSS_COMPILE)gcc' "$@"
	./build_clean.sh noimg
	./build_kernel_e210k.sh CC='$(CROSS_COMPILE)gcc' "$@"
	./build_clean.sh noimg
	./build_kernel_e210l.sh CC='$(CROSS_COMPILE)gcc' "$@"
fi

rm arter97-kernel-"$(cat version)".zip 2>/dev/null
rm *.ko 2>/dev/null
cp *.img kernelzip/
cd kernelzip/
tar -cf - *.img | pixz -9 > img.tar.xz
rm *.img
7z a -mx9 arter97-kernel-"$(cat ../version)"-tmp.zip *
zipalign -v 4 arter97-kernel-"$(cat ../version)"-tmp.zip ../arter97-kernel-"$(cat ../version)".zip
rm arter97-kernel-"$(cat ../version)"-tmp.zip
rm *.tar.xz
cd ..
ls -al arter97-kernel-"$(cat version)".zip
