#!/bin/sh
# build.sh -> build/rebuild kernel
# build.sh zip -> create/recreate zip only

VERSION="release1-$(git rev-parse --short HEAD)"

if [ ! "$1" = "zip" ]; then
	make ARCH=arm n7100_defconfig
	make -j16 ARCH="arm" CROSS_COMPILE="../gcc-arm-none-eabi-4_9-2015q3/bin/arm-none-eabi-"
fi;
cp arch/arm/boot/zImage template/zImage
find . -name "*.ko" -exec cp {} ./template/modules \;
cd template
find . -name placeholder -exec rm -rf {} \;
7z a -mx9 stock-kernel-"$VERSION"-n7100.zip *
mv stock-kernel-"$VERSION"-n7100.zip ..
