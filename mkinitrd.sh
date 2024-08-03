#!/bin/sh

cp /boot/initrd.gz /boot/initrd.gz.old

mkinitrd -c -k 6.9.12-frampt -f btrfs -r /dev/slackware/root -h /dev/slackware/swap -m xhci-pci:ohci-pci:ehci-pci:xhci-hcd:uhci-hcd:ehci-hcd:hid:usbhid:i2c-hid:hid_generic:hid-asus:hid-cherry:hid-logitech:hid-logitech-dj:hid-logitech-hidpp:hid-lenovo:hid-microsoft:hid_multitouch:btrfs:nvidia:nvidia_drm:nvidia_uvm:nvidia_modeset -C /dev/nvme0n1p3 -L -u -o /boot/initrd.gz
