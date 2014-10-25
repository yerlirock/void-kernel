#!/res/busybox sh

export PATH=/res/asset:$PATH

rm -f /dev/bootdone

if cat /data/.arter97/default.profile | grep -q scenario; then
	chmod 666 /sys/class/mdnie/mdnie/scenario
	echo $(cat /data/.arter97/default.profile | grep scenario | sed 's/scenario=//g') > /sys/class/mdnie/mdnie/scenario
	chmod 444 /sys/class/mdnie/mdnie/scenario
else
	chmod 666 /sys/class/mdnie/mdnie/scenario
	echo "8" > /sys/class/mdnie/mdnie/scenario
	chmod 444 /sys/class/mdnie/mdnie/scenario
fi

if cat /data/.arter97/default.profile | grep -q mode; then
	chmod 666 /sys/class/mdnie/mdnie/mode
	echo "$(cat /data/.arter97/default.profile | grep mode | sed 's/mode=//g')" | while read mode; do echo $mode > /sys/class/mdnie/mdnie/mode; done
	chmod 444 /sys/class/mdnie/mdnie/mode
else
	chmod 666 /sys/class/mdnie/mdnie/mode
	echo "0" > /sys/class/mdnie/mdnie/mode
	chmod 444 /sys/class/mdnie/mdnie/mode
fi

if cat /data/.arter97/default.profile | grep -q accessibility; then
	if [[ $(cat /data/.arter97/default.profile | grep accessibility | sed 's/accessibility=//g') == "on" ]]; then
		echo "1" > /sys/class/mdnie/mdnie/accessibility
	else
		echo "0" > /sys/class/mdnie/mdnie/accessibility
	fi
fi

if cat /data/.arter97/default.profile | grep -q mdnie_preset; then
	if [[ $(cat /data/.arter97/default.profile | grep mdnie_preset | sed 's/mdnie_preset=//g') == "on" ]]; then
		echo "1" > /sys/devices/virtual/misc/mdnie_preset/mdnie_preset
	else
		echo "0" > /sys/devices/virtual/misc/mdnie_preset/mdnie_preset
	fi
fi

echo "performance" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo "1024" > /sys/block/mmcblk0/bdi/read_ahead_kb
echo "noop" > /sys/block/mmcblk0/queue/scheduler
if [[ $(cat /data/.arter97/boost_boot) == "1" ]]; then
	echo "$(cat /data/.arter97/boost_boot_cpu_freq)" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
fi

if cat /data/.arter97/default.profile | grep -q logger_mode=0; then
	logcat -c
	echo "0" > /sys/kernel/logger_mode/logger_mode
fi

for file in /sys/block/*/queue/add_random; do echo "0" > $file; done
for file in /sys/block/*/queue/rotational; do echo "0" > $file; done
for file in /sys/block/*/queue/iostats; do echo "0" > $file; done

echo "0" > /sys/devices/virtual/sec/sec_touchkey/touch_led_on_screen_touch
chmod 000 /sys/devices/virtual/sec/sec_touchkey/touch_led_on_screen_touch

while ! pgrep com.android ; do
	sleep 1
done

sleep 5

while pgrep bootanimation ; do
	sleep 1
done
while pgrep samsungani ; do
	sleep 1
done

sleep 5

while pgrep dexopt ; do
	sleep 1
done
while pgrep dex2oat ; do
	sleep 1
done

sleep 5

/res/arter97.sh apply

if cat /data/.arter97/default.profile | grep -q logger_mode=0; then
	logcat -c
	echo "0" > /sys/kernel/logger_mode/logger_mode
fi

touch /dev/bootdone
tinyplay /system/etc/sound/silence.wav -D 0 -d 0 -p 880

sync
