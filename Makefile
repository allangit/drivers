obj-m +:driver.o
all:
	make -C /usr/src/linux-headers-3.16.0-4-amd64/build M=$(PWD) modules
