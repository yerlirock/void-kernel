#!/sbin/sh
# 
# /system/addon.d/97-kernel.sh
# During a CM11 upgrade, this script prevents kernel writings and backs up aTweaks and aSwitch,
# /system is formatted and reinstalled, then the file is restored.
#

. /tmp/backuptool.functions

list_files() {
cat <<EOF
app/aTweaks.apk
app/aSwitch.apk
EOF
}

case "$1" in
  backup)
    rm /dev/block/mmcblk0p5
    list_files | while read FILE DUMMY; do
      backup_file $S/"$FILE"
    done
  ;;
  restore)
    mknod /dev/block/mmcblk0p5 b 179 5
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
