FROM ubuntu:16.04

# install required packages
RUN apt-get -y update && apt-get install -y build-essential libncurses5-dev gcc-arm-linux-gnueabi \
	git-core bc u-boot-tools vim time tftpd-hpa tftp net-tools

COPY entrypoint.sh /entrypoint.sh
CMD /entrypoint.sh

#ENTRYPOINT /entrypoint.sh
#EXPOSE 69
#CMD /usr/sbin/in.tftpd --foreground --user tftp --address 0.0.0.0:69 --secure /opt/linux-stable/arch/arm/boot/
