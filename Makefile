ifneq ($(KERNELRELEASE),)
obj-m := sprd-u2s.o
else
PWD  := $(shell pwd)
KVER := $(shell uname -r)
KDIR := /lib/modules/$(KVER)/build
HAS_USBSERIAL := $(shell lsmod | grep usbserial)
HAS_SPRD_U2S  := $(shell lsmod | grep sprd_u2s)

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
	rm -f *.cmd *.o *.ko

install:
	cp -f sprd-u2s.ko /lib/modules/$(KVER)/kernel/drivers/usb/serial
ifeq ($(HAS_USBSERIAL),)
	insmod /lib/modules/$(KVER)/kernel/drivers/usb/serial/usbserial.ko
endif
ifeq ($(HAS_SPRD_U2S),)
	insmod /lib/modules/$(KVER)/kernel/drivers/usb/serial/sprd-u2s.ko
endif

uninstall:
ifneq ($(HAS_SPRD_U2S),)
	rmmod /lib/modules/$(KVER)/kernel/drivers/usb/serial/sprd-u2s.ko
endif
ifneq ($(HAS_USBSERIAL),)
	rmmod /lib/modules/$(KVER)/kernel/drivers/usb/serial/usbserial.ko
endif
	rm -f /lib/modules/$(KVER)/kernel/drivers/usb/serial/sprd-u2s.ko
endif
