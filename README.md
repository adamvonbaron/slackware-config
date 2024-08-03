### gotchas

1. need to enable pipewire with `pipewire-enable.sh`
2. if bluetooth devices are connecting but not working need to restart hci0 interface
```bash
$ sudo hciconfig hci0 down
$ sudo hciconfig hci0 up
```
3. mkinitrd command is in mkinitrd.sh
