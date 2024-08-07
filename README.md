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


todo: describe how to build/sign nvidia kernel modules and add to initramfs
https://download.nvidia.com/XFree86/Linux-x86/361.45.18/README/installdriver.html#modulesigning

notes to flesh out for finalizing secure boot

1. dont use grub. use systemd-boot
2. use dracut and create a UKI with it. systemd-boot will automatically provide it as
a boot option if it is stored at $ESP/EFI/Linux
3. i probably need to both sign my nvidia kernel modules with my db (shown how to above)
and also keep microsoft's KEK and db certificates in my UEFI NVRAM. I found that not having
Microsoft's keys in my nvram caused my Asus z790 motherboard to raise a secure boot violation
regarding my GPU, and I likely cannot boot my kernel if the modules themselves aren't signed.
4. follow arch wiki on how to manually install systemd-boot
5. Enable the kernel config options CONFIG_MODULE_SIG, CONFIG_MODULE_SIG_ALL,
MODULE_SIG_SHA3_256, and set CONFIG_MODULE_SIG_KEY equal to the location of a file containing
your db private key and certificate in one file, in PEM format. 
you probably just need to do this:
```sh
$ cat db.priv db.pub > db.pem
```
yes they look different (one is ascii base64, the private key, and the public key is... im not sure what it is yet).
the other options tell the kernel's Makefile to build the `sign-file` commmand in /scripts, which will sign
kernel modules with the provided keypair when running `make modules_install`. 
6. only efi binaries can be signed with `sbsign`. this will be systemd-boot itself and the uki created by dracut
