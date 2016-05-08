#!/bin/sh
# build.sh -> build/rebuild kernel
# build.sh zip -> create/recreate zip only
# build.sh .config -> build/rebuild kernel using .config
# build.sh clean -> cleanup repository

export ARCH="arm"
export CROSS_COMPILE="../gcc-arm-none-eabi-5_3-2016q1/bin/arm-none-eabi-"
DEFCONFIG="n7100_defconfig"
JOBS="16"
ZIPNAME="void-kernel-$(cat version)-$(git rev-parse --short HEAD)-n7100.zip"
EXCLUDE=".gitignore modules/placeholder"


if [[ ! "$1" = "clean" ]]; then
	if [[ ! "$1" = "zip" ]]; then
		if [[ ! "$1" = ".config" ]]; then
			make "$DEFCONFIG"; fi
		make -j"$JOBS"; fi

	cp arch/arm/boot/zImage template/zImage
	find . -name "*.ko" -exec cp {} template/modules \;
	cd template
	zip -r9 ../"$ZIPNAME" * -x "$EXCLUDE"
else
	make clean
	make mrproper
	git reset --hard
	git clean -fdx
fi

unset ARCH CROSS_COMPILE
