#!/sbin/sh

/sbin/echo "8" > /sys/class/mdnie/mdnie/scenario
/sbin/echo "7" > /proc/sys/kernel/rom_feature_set

/sbin/mount /data
/sbin/chattr -i /data/app
/sbin/chattr -i /data/app-asec
/sbin/chattr -i /data/app-lib
/sbin/chattr -i /data/app-private
/sbin/chattr -i /data/dalvik-cache
/sbin/chattr -i /data/data
/sbin/chattr -i /data/local
/sbin/umount /data
