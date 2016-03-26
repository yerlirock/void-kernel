#!/bin/sh
# build.sh -> build/rebuild kernel
# build.sh zip -> create/recreate zip only
# build.sh .config -> build/rebuild kernel using .config

ZIP="void-kernel-release3-$(git rev-parse --short HEAD)-n7100"
EXCLUDE=".gitignore modules/placeholder"

if [ ! "$1" = "zip" ]; then
	if [ ! "$1" = ".config" ]; then
		make ARCH=arm n7100_defconfig
	fi
	make -j16 ARCH=arm CROSS_COMPILE="../gcc-arm-none-eabi-4_9-2015q3/bin/arm-none-eabi-"
fi
cp arch/arm/boot/zImage template/zImage
find . -name "*.ko" -exec cp {} template/modules \;
cd template
zip -r9 ../$ZIP * -x $EXCLUDE
