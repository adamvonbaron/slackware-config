### gotchas

1. need to enable pipewire with `pipewire-enable.sh`
2. if bluetooth devices are connecting but not working need to restart hci0 interface
```bash
$ sudo hciconfig hci0 down
$ sudo hciconfig hci0 up
```
3. mkinitrd command is in mkinitrd.sh



#### building kernel and uki for secure boot
1. build and install kernel image like usual
```sh
$ cd /usr/src/linux
$ make nconfig
$ make all -j20
$ make modules_install
$ cp arch/x86/boot/bzImage /boot/vmlinuz-frmapt
$ cp System.map /boot/System.map-frampt
```

2. need to have systemd's UEFI stub for dracut and UKI:
```sh
$ wget https://systemd sourc here
$ tar -xvf ...
$ cd systemd
$ meson setup build
$ ninja -C build
$ DESDIR=./build/dest meson install -C build
$ cp ./build/dest/usr/lib/systemd/boot/* /usr/lib/systemd/boot
$ dracut --host-only --uefi --kernel-image /boot/vmlinuz-frampt
```

3. sign UKI with db key
```sh
$ sbsign --key db.priv --cert db.pub --output /boot/efi/EFI/Linux/linux-frampt.efi /boot/efi/EFI/Linux/linux-frampt.efi
# dracut builds initial EFI binary
```

4. chainload with GRUB or boot directly
```
menuentry 'Slackware UEFI UKI' {
        insmod fat
        insmod chain
        search --no-floppy --fs-uuid --set=root UUID
        chainloader /boot/efi/EFI/Linux/linux-6.9.12-frampt.efi
}
```
