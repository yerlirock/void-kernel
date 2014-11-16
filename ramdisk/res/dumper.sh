#!/res/busybox sh

export PATH=/res/asset:$PATH

if cat /proc/last_kmsg | grep -q "Kernel panic"; then
	mkdir -p /sdcard/arter97 2>/dev/null
	cat /proc/last_kmsg > /sdcard/arter97/panic_$(date +%s).log
	dmesg -c
	sync
fi
