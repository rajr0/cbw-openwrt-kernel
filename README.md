This kernel is built for OCP whitebox enterprise class high performance white box Wi-Fi Access Points.<br />
H/W specifications are available here http://www.opencompute.org/wiki/Networking/SpecsAndDesigns <br />
Highlights of H/W capabilities : <br />
- Dual core ARM based Broadcom SoC (1.2 GHz core) <br />
- 3x3 AC MIMO with beamforming <br />
- dual band 2.4/5 ; 1 Gb/s WAN connection <br />
<br />


# Build under Linux
```
git clone https://github.com/opencomputeproject/cbw-openwrt-kernel
cd cbw-openwrt-kernel
docker build -t ocp .
docker run -v `pwd`/opt:/opt -it ocp
```

folder './opt' should contain compiled binary file:
```
openwrt-bcm53xx-edgecore-ecw7220-l-squashfs.trx
```

folder './opt/openwrt' is a full OpenWRT tree used for compilation.

# Build under OSx

default Mac filesystem is case-insensitive and not compatible with OpenWRT build system.
So, we need to make case-sensitive volume and build inside this volume. Here is a commands
to do this:

```
git clone https://github.com/opencomputeproject/cbw-openwrt-kernel
cd cbw-openwrt-kernel
docker build -t ocp .
hdiutil create -size 20g -fs "Case-sensitive HFS+" -volname OpenWrt OpenWrt.dmg
hdiutil attach OpenWrt.dmg
cd /Volumes/OpenWrt
docker run -v `pwd`/opt:/opt -it ocp
```

#Flashing OpenWRT kernel+rootfs+ubifs to AP

#Starting TFTP Server on OSX

```
sudo cp openwrt-bcm53xx-edgecore-ecw7220-l-squashfs.trx /private/tftpboot/
sudo launchctl load -F /System/Library/LaunchDaemons/tftp.plist
sudo launchctl start com.apple.tftpd
```

Copy binary file (openwrt-bcm53xx-edgecore-ecw7220-l-squashfs.trx) to TFTP server directory and boot AP to u-boot shell.<br />
If you power up the AP, you'd have 2-3 seconds to press any key on the AP console to break into u-boot

Set AP IP address to IP address of choice
```
u-boot> setenv ipaddr X.X.X.X /* where X.X.X.X is the IP you want to provide to your AP */
u-boot> printenv  /* To check if got set right */
```
Then issue following commands in u-boot shell (do not type 'u-boot> ' part, replace 192.168.1.121 to IP-address of your TFTP server):

```
u-boot> tftpboot 0x82000000 192.168.1.121:openwrt-bcm53xx-edgecore-ecw7220-l-squashfs.trx
u-boot> nand erase 0x00680000 0x2800000
u-boot> nand write 0x82000000 0x680000 ${filesize}
u-boot> run boot2
```

this commands writes OpenWRT image to NAND flash and then boot AP.

here is a console output if everything is ok:
```
[    0.000000] Linux version 4.4.14 (aospan@a-desktop) (gcc version 5.3.0 (OpenWrt GCC 5.3.0 50101) ) #8 SMP Tue Feb 7 00:22:35 UTC 2017
...
[    0.003188] Brought up 2 CPUs
...
[    7.709905] UBIFS (ubi0:1): default file-system created
[    7.716050] UBIFS (ubi0:1): background thread "ubifs_bgt0_1" started, PID 397
[    7.782047] UBIFS (ubi0:1): UBIFS: mounted UBI device 0, volume 1, name "rootfs_data"
[    7.789912] UBIFS (ubi0:1): LEB size: 126976 bytes (124 KiB), min./max. I/O unit sizes: 2048 bytes/2048 bytes
[    7.799883] UBIFS (ubi0:1): FS size: 100945920 bytes (96 MiB, 795 LEBs), journal size 5079040 bytes (4 MiB, 40 LEBs)
[    7.810444] UBIFS (ubi0:1): reserved for root: 4767925 bytes (4656 KiB)
[    7.817080] UBIFS (ubi0:1): media format: w4/r0 (latest is w4/r0), UUID 349888C2-2168-45D4-BDFC-26AB90F4DDFB, small LPT model
[    7.830313] mount_root: overlay filesystem has not been fully initialized yet
[    7.837938] mount_root: switching to jffs2 overlay
...
[   12.338414] b43-phy1: Broadcom 43431 WLAN found (core revision 29)
...
[   10.435460] ath10k_pci 0000:01:00.0: enabling device (0140 -> 0142)
...
[   17.710242] bgmac bcma0:3 eth0: Link is Up - 1Gbps/Full - flow control off
...
BusyBox v1.24.2 () built-in shell (ash)

                                @@@@@@                                       
    &@&                           @@@@@@                                       
   @@@@@@.                        @@@@@@                                       
  @@@@@@@@@@                      @@@@@@                                       
    ,@@@@@@@@@#                   @@@@@@                                       
       @@@@@@@@@@                 @@@@@@                                       
          @@@@@@@@@@              @@@@@@                                       
            ,@@@@@@@@@#           @@@@@@                                       
               @@@@@@@@@@         @@@@@@                                       
                  @@@@@@@@@@      @@@@@@                                       
                    /@@@@@@@@@#   @@@@@@     @@@@@@&                           
                       @@@@@@@@@@ @@@@@@    @@&                                
                          @@@@@@@@@@@@@@    @@                                 
                            /@@@@@@@@@@@    @@,       @@@@@@@                  
                               @@@@@@@@@@   ,@@@%%@@  @@.  @@,                 
                                  @@@@@@@@@@          @@@@@@,                  
                                  @@@@@@@@@@@@/       @@.  *@@                 
                                  @@@@@@@@@@@@@@@     @@,.,@@@ ,@@    *        
                                  @@@@@@* @@@@@@@@@&           .@@   @@@    @@ 
                                  @@@@@@/   #@@@@@@@@@.        .@@  @@@@   @@  
                                  @@@@@@(      @@@@@@@@@@       @@,@& @@  @@   
                                  @@@@@@#         @@@@@@@@@@    @@@@  @@ @@    
                                  @@@@@@%           #@@@@@@@@@,  /(   @@@@     
                                  @@@@@@%              @@@@@@@@@@              
                                  @@@@@@&                .@@@@@@@@@@           
                                  &@@@@@&                   &@@@@@@@@@,        
                                  &@@@@@@                      @@@@@@@@        
                                                                 .@@@          
root@OpenWrt:/#
```

(c) Abylay Ospan, Joker Systems Inc., 2017, License: GPLv2
https://jokersys.com
&
Rajat Ghai (OCP - CBW)
