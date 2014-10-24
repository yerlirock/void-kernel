#!/bin/bash
export KERNELDIR=`readlink -f .`
export RAMFS_SOURCE=`readlink -f $KERNELDIR/ramdisk`
export USE_SEC_FIPS_MODE=true

echo "kerneldir = $KERNELDIR"
echo "ramfs_source = $RAMFS_SOURCE"

RAMFS_TMP="/tmp/arter97-ramdisk"

echo "ramfs_tmp = $RAMFS_TMP"
cd $KERNELDIR

if [ "${1}" = "skip" ] ; then
	echo "Skipping Compilation"
else
	echo "Compiling kernel"
	cp defconfig .config
	scripts/configcleaner "
CONFIG_TARGET_LOCALE_USA
CONFIG_TARGET_LOCALE_KOR
CONFIG_MACH_C1_KOR_SKT
CONFIG_MACH_C1_KOR_KT
CONFIG_MACH_C1_KOR_LGT
CONFIG_MACH_M0
CONFIG_SEC_MODEM_M0
CONFIG_SEC_MODEM_C1
CONFIG_SEC_MODEM_C1_LGT
CONFIG_USBHUB_USB3503
CONFIG_UMTS_MODEM_XMM6262
CONFIG_LTE_MODEM_CMC221
CONFIG_IP_MULTICAST
CONFIG_LINK_DEVICE_DPRAM
CONFIG_LINK_DEVICE_USB
CONFIG_LINK_DEVICE_HSIC
CONFIG_IPC_CMC22x_OLD_RFS
CONFIG_SIPC_VER_5
CONFIG_SAMSUNG_MODULES
CONFIG_FM
CONFIG_FM_RADIO
CONFIG_FM_SI4709
CONFIG_FM_SI4705
CONFIG_WLAN_REGION_CODE
CONFIG_LTE_VIA_SWITCH
CONFIG_BRIDGE
CONFIG_FM34_WE395
CONFIG_CDMA_MODEM_CBP72
CONFIG_DMA_CMA
CONFIG_DMA_CMA_DEBUG
CONFIG_CMA_SIZE_MBYTES
CONFIG_CMA_SIZE_SEL_MBYTES
CONFIG_CMA_SIZE_SEL_PERCENTAGE
CONFIG_CMA_SIZE_SEL_MIN
CONFIG_CMA_SIZE_SEL_MAX
CONFIG_CMA_ALIGNMENT
CONFIG_CMA_AREAS
CONFIG_TDMB
CONFIG_TDMB_SPI
CONFIG_TDMB_EBI
CONFIG_TDMB_TSIF
CONFIG_TDMB_VENDOR_FCI
CONFIG_TDMB_VENDOR_INC
CONFIG_TDMB_VENDOR_RAONTECH
CONFIG_TDMB_MTV318
CONFIG_TDMB_VENDOR_TELECHIPS
CONFIG_TDMB_SIMUL
CONFIG_TDMB_ANT_DET
"
	echo "
# CONFIG_TARGET_LOCALE_USA is not set
CONFIG_TARGET_LOCALE_KOR=y
CONFIG_MACH_C1_KOR_SKT=y
# CONFIG_MACH_C1_KOR_KT is not set
# CONFIG_MACH_C1_KOR_LGT is not set
# CONFIG_MACH_M0 is not set
CONFIG_MACH_C1=y
CONFIG_CMC_MODEM_HSIC_SYSREV=9
# CONFIG_SEC_MODEM_M0 is not set
CONFIG_SEC_MODEM_C1=y
CONFIG_MACH_NO_WESTBRIDGE=y
CONFIG_IP_MULTICAST=y
# CONFIG_FM34_WE395 is not set
CONFIG_USBHUB_USB3503=y
# CONFIG_USBHUB_USB3503_OTG_CONN is not set
# CONFIG_UMTS_MODEM_XMM6262 is not set
CONFIG_LTE_MODEM_CMC221=y
CONFIG_LINK_DEVICE_DPRAM=y
CONFIG_LINK_DEVICE_USB=y
# CONFIG_LINK_DEVICE_HSIC is not set
CONFIG_IPC_CMC22x_OLD_RFS=y
CONFIG_SIPC_VER_5=y
# CONFIG_SAMSUNG_MODULES is not set
CONFIG_WLAN_REGION_CODE=201
# CONFIG_LTE_VIA_SWITCH is not set
# CONFIG_SEC_MODEM_C1_LGT is not set
# CONFIG_BRIDGE is not set
# CONFIG_CDMA_MODEM_CBP72 is not set
# CONFIG_FM_RADIO is not set
# CONFIG_FM_SI4709 is not set
# CONFIG_FM_SI4705 is not set
# CONFIG_DMA_CMA is not set
CONFIG_TDMB=y
CONFIG_TDMB_SPI=y
# CONFIG_TDMB_EBI is not set
# CONFIG_TDMB_TSIF is not set
# CONFIG_TDMB_VENDOR_FCI is not set
# CONFIG_TDMB_VENDOR_INC is not set
CONFIG_TDMB_VENDOR_RAONTECH=y
CONFIG_TDMB_MTV318=y
# CONFIG_TDMB_VENDOR_TELECHIPS is not set
# CONFIG_TDMB_SIMUL is not set
# CONFIG_TDMB_ANT_DET is not set
" >> .config
	make "$@" || exit 1
fi

echo "Building new ramdisk"
#remove previous ramfs files
rm -rf '$RAMFS_TMP'*
rm -rf $RAMFS_TMP
rm -rf $RAMFS_TMP.cpio
#copy ramfs files to tmp directory
cp -ax $RAMFS_SOURCE $RAMFS_TMP
rm $RAMFS_TMP/sbin/cbd
cp -p e210/cbd $RAMFS_TMP/sbin/
cd $RAMFS_TMP

cp -rp ramdisks/samsung/jellybean/e210s/* ramdisks/samsung/jellybean/
rm -rf ramdisks/samsung/jellybean/e210s
rm -rf ramdisks/samsung/jellybean/e210k
rm -rf ramdisks/samsung/jellybean/e210l
rm -rf ramdisks/samsung/jellybean/m440s
rm -rf ramdisks/samsung/jellybean/i9300

echo "SHV-E210S" > ro.hardware

find . -name "*smdk4x12*" | grep -v asset | while read file; do mv -f "$file" "$(echo $file | sed s/smdk4x12/SHV-E210S/g)"; done
find . -name "*rc*" | grep -v asset | while read file; do sed -i s/smdk4x12/SHV-E210S/g $file ; done
echo "
setprop net.tcp.buffersize.default 4096,87380,110208,4096,16384,110208
setprop net.tcp.buffersize.lte 4094,281250,1220608,4096,140625,1220608
setprop net.tcp.buffersize.umts 4094,87380,1220608,4096,16384,1220608
setprop net.tcp.buffersize.hspa 4094,87380,1220608,4096,16384,1220608
setprop net.tcp.buffersize.hsupa 4094,87380,1220608,4096,16384,1220608
setprop net.tcp.buffersize.hsdpa 4094,87380,1220608,4096,16384,1220608
setprop net.tcp.buffersize.hspap 4094,87380,1220608,4096,16384,1220608
setprop net.tcp.buffersize.edge 4093,26280,35040,4096,16384,35040
setprop net.tcp.buffersize.gprs 4092,8760,11680,4096,8760,1" >> arter97.sh

find . -name '*.sh' -exec chmod 755 {} \;

$KERNELDIR/ramdisk_fix_permissions.sh 2>/dev/null

/bin/ls ramdisks/ | grep -v samsung | while read ramdisk; do
	cd ramdisks/$ramdisk
	echo fixing permisions on $(pwd)
	sed -i -e 's/write \/sys\/class\/mdnie\/mdnie\/mode 0/write \/sys\/class\/mdnie\/mdnie\/mode 0\n\n# tdmb ownership\n    chown system system \/dev\/tdmb\n    chmod 0660 \/dev\/tdmb/g' init.SHV-E210S.rc 2>/dev/null
	$KERNELDIR/ramdisk_fix_permissions.sh 2>/dev/null
	cd ../..
done

/bin/ls ramdisks/samsung/ | while read ramdisk; do
	cd ramdisks/samsung/$ramdisk
	echo fixing permisions on $(pwd)
	$KERNELDIR/ramdisk_fix_permissions.sh 2>/dev/null
	cd ../../..
done

rm -f ramdisks/samsung/*/sbin/cbd

#clear git repositories in ramfs
find . -name .git -exec rm -rf {} \;
find . -name EMPTY_DIRECTORY -exec rm -rf {} \;
cd $KERNELDIR
rm -rf $RAMFS_TMP/tmp/*

rm *.ko 2>/dev/null
find . -name "*.ko" -exec cp {} . \;
ls *.ko | while read file; do /home/arter97/toolchain/bin/arm-linux-gnueabihf-strip --strip-unneeded $file ; done
cp -av *.ko $RAMFS_TMP/lib/modules/
chmod 644 $RAMFS_TMP/lib/modules/*
cd $RAMFS_TMP
find . | fakeroot cpio -H newc -o | lzma -e -9 > $RAMFS_TMP.cpio.lzma
ls -lh $RAMFS_TMP.cpio.lzma
cd $KERNELDIR

echo "Making new boot image"
./mkbootimg --kernel $KERNELDIR/arch/arm/boot/zImage --ramdisk $RAMFS_TMP.cpio.lzma --board smdk4x12 --cmdline 'ttySAC2,115200' --base 0x40000000 --pagesize 2048 -o $KERNELDIR/e210s.img
if [ "${1}" = "CC=\$(CROSS_COMPILE)gcc" ] ; then
	dd if=/dev/zero bs=$((8388608-$(stat -c %s e210s.img))) count=1 >> e210s.img
fi

echo "done"
ls -al e210s.img
echo ""
ls -al *.ko
