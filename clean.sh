#!/bin/bash

make clean && make mrproper
git reset --hard
git clean -fdx
