#!/sbin/sh
# 
# /system/addon.d/97-kernel.sh
# During a CM11 upgrade, this script prevents kernel writings and backs up aTweaks and aSwitch,
# /system is formatted and reinstalled, then the file is restored.
#

rm /dev/block/mmcblk0p5

. /tmp/backuptool.functions

list_files() {
cat <<EOF
app/aTweaks.apk
app/aSwitch.apk
bin/hostapd
lib/egl/libEGL_mali.so
lib/egl/libGLESv1_CM_mali.so
lib/egl/libGLESv2_mali.so
lib/libMali.so
lib/libUMP.so
vendor/firmware/SlimISP_BH.bin
vendor/firmware/SlimISP_GD.bin
vendor/firmware/SlimISP_GH.bin
vendor/firmware/SlimISP_GK.bin
vendor/firmware/SlimISP_JH.bin
vendor/firmware/SlimISP_PH.bin
vendor/firmware/SlimISP_WH.bin
vendor/firmware/SlimISP_ZD.bin
vendor/firmware/SlimISP_ZH.bin
vendor/firmware/SlimISP_ZK.bin
vendor/firmware/SlimISP_ZM.bin
EOF
}

case "$1" in
  backup)
    list_files | while read FILE DUMMY; do
      backup_file $S/"$FILE"
    done
  ;;
  restore)
    list_files | while read FILE REPLACEMENT; do
      R=""
      [ -n "$REPLACEMENT" ] && R="$S/$REPLACEMENT"
      [ -f "$C/$S/$FILE" ] && restore_file $S/"$FILE" "$R"
    done
  ;;
  pre-backup)
    # Stub
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
    # Stub
  ;;
  post-restore)
    # Stub
  ;;
esac
