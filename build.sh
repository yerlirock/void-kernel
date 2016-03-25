#!/bin/sh
# build.sh -> build/rebuild kernel
# build.sh zip -> create/recreate zip only

ZIP="void-kernel-release2-$(git rev-parse --short HEAD)"
EXCLUDE=".gitignore modules/placeholder"

if [ ! "$1" = "zip" ]; then
	make ARCH=arm n7100_defconfig
	make -j16 ARCH=arm CROSS_COMPILE="../gcc-arm-none-eabi-4_9-2015q3/bin/arm-none-eabi-"
fi;
cp arch/arm/boot/zImage template/zImage
find . -name "*.ko" -exec cp {} template/modules \;
cd template
zip -r9 ../$ZIP * -x $EXCLUDE
