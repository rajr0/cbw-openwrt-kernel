#!/bin/bash
# Build OpenWRT inside docker container
# Resulting file /opt/openwrt-bcm53xx-edgecore-ecw7220-l-squashfs.trx
# (c) Abylay Ospan, Joker Systems Inc., 2017
# License: GPLv2

set -e

cd /opt

# Build OpenWRT
if [ ! -d "openwrt" ]; then
	git clone -b ocp --depth=1 https://github.com/aospan/openwrt.git && cd openwrt
	cp /openwrt.config ./.config
	./scripts/feeds update -a && ./scripts/feeds install -a
else
	cd openwrt && git pull --rebase
fi

export FORCE=1
export FORCE_UNSAFE_CONFIGURE=1

CONFDEFAULT=y make -j1 V=s oldconfig

make -j"$(nproc)"

#copy result to /opt
cp ./bin/bcm53xx/openwrt-bcm53xx-edgecore-ecw7220-l-squashfs.trx /opt/
