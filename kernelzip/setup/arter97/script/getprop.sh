#!/tmp/arter97/busybox sh

if [ -z "$(getprop ro.hardware)" ] && [ -z "$(getprop ro.boot.hardware)" ]; then
	/tmp/arter97/busybox echo "hardware=err" > /tmp/arter97/hardware.prop
	return 1
fi

device=""
if [ ! -z "$(getprop ro.hardware)" ]; then
	device=$(getprop ro.hardware)
fi
if [ ! -z "$(getprop ro.boot.hardware)" ]; then
	device=$(getprop ro.boot.hardware)
fi

if [[ $device != "smdk4x12" ]] && [[ $device != "SHW-M440S" ]] && [[ $device != "SHV-E210S" ]] && [[ $device != "SHV-E210K" ]] && [[ $device != "SHV-E210L" ]]; then
	/tmp/arter97/busybox echo "hardware=err" > /tmp/arter97/hardware.prop
	return 1
else
	/tmp/arter97/busybox echo "hardware=$device" > /tmp/arter97/hardware.prop
fi
