#!/bin/bash
git fetch f2fs

find . -not -path '*/\.*' -name '*f2fs*' | grep -v 'update_f2fs\|recovery' | while read f2fs; do rm -rf $f2fs; git checkout f2fs/dev -- $f2fs; done

rm -rf fs/f2fs
git checkout f2fs/dev -- fs/f2fs

git log --oneline f2fs/linux-3.4 | head -1 | awk '{print $1}' | while read patch; do git cherry-pick --no-commit $patch; done
git cherry-pick --no-commit f0d700429e936040f9968a6fd3c089a42d2e4c5f
git cherry-pick --no-commit 39b4ce86558eacb1696f1d5ebf0d365215f95973
git cherry-pick --no-commit d32b0fa44d84a69a217854e27ef5f2214784249b

git status
