#!/bin/bash
git fetch f2fs

find . -not -path '*/\.*' -name '*f2fs*' | grep -v 'update_f2fs\|recovery\|ramdisk' | while read f2fs; do rm -rf $f2fs; git checkout f2fs/dev -- $f2fs; done

rm -rf fs/f2fs
git checkout f2fs/dev -- fs/f2fs

git log --oneline f2fs/linux-3.4 | head -1 | awk '{print $1}' | while read patch; do git cherry-pick --no-commit $patch; done
git cherry-pick --no-commit 198c01d48db87777d317659a939cc1223c618142
git cherry-pick --no-commit 1eca534550458ed2a67aba3f32b55a5434524988
git cherry-pick --no-commit 2fd13f44ff806d34705aa431a4fe94534e511960
git cherry-pick --no-commit 73a790dd966a423140ab65b7b025fa8b82d2206f

git status
