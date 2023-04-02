# HP Notebook 14-dq1033cl
## Handling Hardware Airplane mode issues in Ubuntu 22.04 

### Edit grub and include kernel parameters

`sudo nano /etc/default/grub` #Open grub for edit and include kernelt parameters in GRUB_CMDLINE_LINUX_DEFAULT=

```
#Default is below
#GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"

#Works - Fn keys, Suspend on close, Locked on Open, Airplane mode toggle. Touchpad made to work with 'i8042.nopnp=1 pci=nocrs'
#Does not work - Wifi on boot (i.e. boots in Airplane mode).  'rfkill.default_state=1' did not help
GRUB_CMDLINE_LINUX_DEFAULT="acpi_osi=! acpi_osi='Linux'i8042.nopnp=1 pci=nocrs quiet splash"
```

`sudo update-grub` #Update grub and reboot

**Note:** 
1.  The system will boot only with airplane mode turned on. Press Fn+f12 twice leaving a gap of a few seconds for Wifi to turn on. 
2.  When the lid is closed, and opened, the screen will be locked, but airplane mode will be on. Press Fn+f12 twice leaving a gap of a few seconds for Wifi to turn on. 
