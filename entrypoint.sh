#!/bin/bash
set -e

cd /opt

if [ ! -d "linux-stable" ]; then
    git clone --depth=1 -b ocp-linux-4.9.y https://github.com/aospan/linux-stable.git
fi

cd linux-stable 

if [ ! -f ".config" ]; then
    make -j 2 LOADADDR=0x82008000 ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- ecw7220l_defconfig
fi

time make -j 2 LOADADDR=0x82008000 ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- uImage
make -j 2 LOADADDR=0x82008000 ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- arch/arm/boot/dts/

#copy result to /opt
cp arch/arm/boot/uImage /opt/
cp arch/arm/boot/dts/bcm4708-edgecore-ecw7220-l.dtb /opt/
