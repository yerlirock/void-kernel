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
CONFIG_BRIDGE_NETFILTER
CONFIG_NETFILTER_XT_MATCH_PHYSDEV
CONFIG_BRIDGE_NF_EBTABLES
CONFIG_BRIDGE_IGMP_SNOOPING
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
# CONFIG_MACH_C1_KOR_SKT is not set
# CONFIG_MACH_C1_KOR_KT is not set
CONFIG_MACH_C1_KOR_LGT=y
# CONFIG_MACH_M0 is not set
CONFIG_MACH_C1=y
CONFIG_CMC_MODEM_HSIC_SYSREV=11
# CONFIG_SEC_MODEM_M0 is not set
# CONFIG_SEC_MODEM_C1 is not set
CONFIG_SEC_MODEM_C1_LGT=y
CONFIG_MACH_NO_WESTBRIDGE=y
CONFIG_IP_MULTICAST=y
CONFIG_FM34_WE395=y
CONFIG_USBHUB_USB3503=y
# CONFIG_USBHUB_USB3503_OTG_CONN is not set
# CONFIG_UMTS_MODEM_XMM6262 is not set
CONFIG_LTE_MODEM_CMC221=y
CONFIG_LINK_DEVICE_DPRAM=y
CONFIG_LINK_DEVICE_USB=y
# CONFIG_LINK_DEVICE_HSIC is not set
# CONFIG_IPC_CMC22x_OLD_RFS is not set
CONFIG_SIPC_VER_5=y
# CONFIG_SAMSUNG_MODULES is not set
CONFIG_WLAN_REGION_CODE=203
CONFIG_LTE_VIA_SWITCH=y
CONFIG_BRIDGE=y
CONFIG_CDMA_MODEM_CBP72=y
# CONFIG_FM_RADIO is not set
# CONFIG_FM_SI4709 is not set
# CONFIG_FM_SI4705 is not set
CONFIG_BRIDGE_NETFILTER=y
# CONFIG_NETFILTER_XT_MATCH_PHYSDEV is not set
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
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

cp -rp ramdisks/samsung/kitkat/e210l/* ramdisks/samsung/kitkat/
rm -rf ramdisks/samsung/kitkat/e210l

echo "SHV-E210L" > ro.hardware

find . -name "*smdk4x12*" | grep -v asset | while read file; do mv -f "$file" "$(echo $file | sed s/smdk4x12/SHV-E210L/g)"; done
find . -name "*rc*" | grep -v asset | while read file; do sed -i s/smdk4x12/SHV-E210L/g $file ; done
# so freaking-annoying HELL-G partition fix
sed -i -e s/mmcblk0p12/mmcblk0p13/g -e s/mmcblk0p11/mmcblk0p12/g -e s/mmcblk0p10/mmcblk0p11/g -e s/mmcblk0p9/mmcblk0p10/g -e s/mmcblk0p8/mmcblk0p9/g res/alt_init
sed -i -e 's/mknod \/dev\/block\/mmcblk0p13 b 179 12/mknod \/dev\/block\/mmcblk0p13 b 179 13/g' -e 's/mknod \/dev\/block\/mmcblk0p10 b 179 9/mknod \/dev\/block\/mmcblk0p10 b 179 10/g' -e 's/mknod \/dev\/block\/mmcblk0p9 b 179 8/mknod \/dev\/block\/mmcblk0p9 b 179 9/g' -e 's/mknod \/dev\/block\/mmcblk0p11 b 179 10/mknod \/dev\/block\/mmcblk0p11 b 179 11/g' res/alt_init
find . -name "*rc*" | grep -v asset | while read file; do sed -i -e s/mmcblk0p12/mmcblk0p13/g -e s/mmcblk0p11/mmcblk0p12/g -e s/mmcblk0p10/mmcblk0p11/g -e s/mmcblk0p9/mmcblk0p10/g -e s/mmcblk0p8/mmcblk0p9/g $file ; done
find . -name "*fstab*" | grep -v asset | while read file; do sed -i -e s/mmcblk0p12/mmcblk0p13/g -e s/mmcblk0p11/mmcblk0p12/g -e s/mmcblk0p10/mmcblk0p11/g -e s/mmcblk0p9/mmcblk0p10/g -e s/mmcblk0p8/mmcblk0p9/g $file ; done
find . -name "*.sh" | grep -v asset | while read file; do sed -i -e s/mmcblk0p12/mmcblk0p13/g -e s/mmcblk0p11/mmcblk0p12/g -e s/mmcblk0p10/mmcblk0p11/g -e s/mmcblk0p9/mmcblk0p10/g -e s/mmcblk0p8/mmcblk0p9/g $file ; done
# so freaking-annoying HELL-G communication-fix
# Thanks to gal3(?), ckh469 in develoid
# LG: goto hell

find . -name '*.sh' -exec chmod 755 {} \;

$KERNELDIR/ramdisk_fix_permissions.sh 2>/dev/null

/bin/ls ramdisks/ | grep -v samsung | while read ramdisk; do
	cd ramdisks/$ramdisk
	echo fixing permisions on $(pwd)
	sed -i -e 's/\/dev\/umts_rfs0                          u:object_r:radio_device:s0/\/dev\/umts_rfs0                          u:object_r:radio_device:s0\n\/dev\/cdma_boot0                         u:object_r:radio_device:s0\n\/dev\/cdma_ipc0                          u:object_r:radio_device:s0\n\/dev\/cdma_rfs0                          u:object_r:radio_device:s0\n\/dev\/cdma_multipdp                      u:object_r:radio_device:s0\n\/dev\/cdma_rmnet[0-6]*                   u:object_r:radio_device:s0\n\/dev\/cdma_ramdump0                      u:object_r:radio_device:s0\n\/dev\/cdma_cplog                         u:object_r:radio_device:s0/g' file_contexts 2>/dev/null
	sed -i -e 's/group radio cache inet misc audio sdcard_rw qcom_oncrpc qcom_diag log/group radio cache inet misc audio sdcard_rw log\n    onrestart restart cbd-lte\n    onrestart restart cbd-cdma/g' init.rc 2>/dev/null
	sed -i "/# cbd/,/group radio cache inet misc audio sdcard_rw log/d" init.target.rc 2>/dev/null
	sed -i -e 's/# GPS/# cbd\nservice cbd-lte \/sbin\/cbd -d -t cmc221 -b d -m d\n    class main\n    user root\n    group radio cache inet misc audio sdcard_rw log\n    seclabel u:r:cbd:s0\n\nservice cbd-cdma \/sbin\/cbd -d -t cbp72 -b u -m d\n    class main\n    user root\n    group radio cache inet misc audio sdcard_rw log\n    seclabel u:r:cbd:s0\n\n# GPS/g' init.target.rc 2>/dev/null
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
ls *.ko | while read file; do $(cat Makefile | grep CROSS_COMPILE | grep arm | awk '{print $3}')strip --strip-unneeded $file ; done
cp -av *.ko $RAMFS_TMP/lib/modules/
chmod 644 $RAMFS_TMP/lib/modules/*
cd $RAMFS_TMP
find . | fakeroot cpio -H newc -o | lzma -e -9 > $RAMFS_TMP.cpio.lzma
ls -lh $RAMFS_TMP.cpio.lzma
cd $KERNELDIR

echo "Making new boot image"
gcc -w -s -pipe -O2 -Itools/libmincrypt -o tools/mkbootimg/mkbootimg tools/libmincrypt/*.c tools/mkbootimg/mkbootimg.c
tools/mkbootimg/mkbootimg --kernel $KERNELDIR/arch/arm/boot/zImage --ramdisk $RAMFS_TMP.cpio.lzma --board smdk4x12 --cmdline 'ttySAC2,115200 enforcing=0' --base 0x40000000 --pagesize 2048 -o $KERNELDIR/e210l.img
if [ "${1}" = "CC=\$(CROSS_COMPILE)gcc" ] ; then
	dd if=/dev/zero bs=$((8388608-$(stat -c %s e210l.img))) count=1 >> e210l.img
fi

echo "done"
ls -al e210l.img
echo ""
ls -al *.ko
