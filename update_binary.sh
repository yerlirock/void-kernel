#!/bin/bash

# update update-binary from http://get.cm/?device=i9300 latest nightly
# by arter97
#
# dependencies : p7zip, unpackbootimg, cpio

rm -rf tmp
mkdir tmp

export date=$(($(date +'%Y%m%d') + 2))
wget http://get.cm/?device=i9300 || exit 1
until cat index.html\?device\=i9300 | grep $date | grep cm-11 | tr '\"' '\n' | grep jenkins | grep -v http ; do
	export date=$(($date - 1))
done
rm -rf /tmp/arter97_update_binary
mkdir /tmp/arter97_update_binary

until wget -P /tmp/arter97_update_binary/ http://get.cm$(cat index.html\?device\=i9300 | grep $date | tr '\"' '\n' | grep jenkins | grep -v http); do
	rm -rf /tmp/arter97_update_binary/*.zip
done

cd kernelzip

rm META-INF/com/google/android/update-binary
7z x /tmp/arter97_update_binary/*.zip META-INF/com/google/android/update-binary

cd ..
git reset

rm -rf /tmp/arter97_update_binary index.html\?device\=i9300

echo ""
echo DONE!
