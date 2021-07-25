# Speeding up the boot process
Run `DisableUnnecessaryServices.sh` to disable `NetworkManager-wait-online.service` , `plymouth-quit-wait.service` , `ModemManager.service` , `ofono.service` (IF Installed)

Remove `splash` in this line in `/etc/default/grub` and `usbcore.autosuspend=-1` to make the mic in the USB Web Cam work.

`#GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"` to `GRUB_CMDLINE_LINUX_DEFAULT="quiet usbcore.autosuspend=-1"`and run `sudo update-grub`

## udisks2 raid warnings

Check if there are any warnings (or error messages) from udisks2 about raid (such as here https://bugs.launchpad.net/ubuntu/+source/udisks2/+bug/1811724) by executing

 `journalctl -b | grep udisks` or `sudo systemctl status udisks2`

If there are messages like "failed to load module mdraid: libbd_mdraid.so.2: cannot open shared object file: No such file or directory" or "Failed to load the 'mdraid' libblockdev plugin", then install the 2 missing packages
 
`sudo apt-get install libblockdev-crypto2 libblockdev-mdraid2`
 
Restart udisks2 and check its status to see if the warnings are gone
 
`sudo systemctl restart udisks2`
 
`sudo systemctl status udisks2`

## blueman prompt / error requiring every user to authenticate with sudo privilleges upon login

View `blueman.rules` with

`cat /usr/share/polkit-1/rules.d/blueman.rules`

```
// Allow users in sudo or netdev group to use blueman feature requiring root without authentication
polkit.addRule(function(action, subject) {
    if ((action.id == "org.blueman.network.setup" ||
         action.id == "org.blueman.dhcp.client" ||
         action.id == "org.blueman.rfkill.setstate" ||
         action.id == "org.blueman.pppd.pppconnect") &&
        subject.local && subject.active &&
        (subject.isInGroup("sudo") || subject.isInGroup("netdev"))) {
        return polkit.Result.YES;
    }
});

```

Confirm if the logged in user belongs to `netdev` group by executing 

`groups`

If not, include them in `netdev` group by executing

`sudo gpasswd -a ${USER} netdev` and check again by executing `groups`


## Allow multicast incoming pings / packets from your router if you use UFW

Add the following rule where `192.168.254.1` is an example of your router's IP address

`sudo ufw allow in from 192.168.254.1 to 224.0.0.0/24` - Refer - https://bbs.archlinux.org/viewtopic.php?id=212452 or https://forums.linuxmint.com/viewtopic.php?t=111630

Then reload the firewall

`sudo ufw reload`

and check the status

`sudo ufw status verbose`


## Create common mount points for partitions commonly accessed by all users and include them in fstab.
This will help in avoiding warnings in `journalctl -u udisks2` whenever a super user who mounted these partitions re-boots as these warning rould appear as the boot process tries to re-mount those partition with the <username> in their path and it cannot do it as the user is not logged in yet. This warning will look like `udisksd[695]: mountpoint /media/<username>/<partition-name> is invalid, cannot recover the canonical path`
 
`sudo mkdir /media/all-users-<partition-name>` creates a common mount point for all users

`sudo blkid | grep UUID=` gets the UUID of those partitions

`sudo nano /etc/fstab` opens fstab to put the mount point against the UUID
 
 ```
# The below line is added so that the path to the CommonData partition is common for all users
# Change between auto and noauto based on whether to mount this partition automatically at boot
UUID=99999999-9999-9999-9999-999999999999 /media/all-users-<partition-name> ext4 noauto,nosuid,nodev,noexec,nouser,nofail 0 0
```
 
## Only for Dell Inspiron 1720 with NVIDIA G86M [GeForce 840M GS] Graphics card
### Driver Installation error
Install NVIDIA binary driver - vesion 340.108 from nvidia-340 (properitary, tested) from "Additional Drivers" in the GUI. If you get an error as below
``` 
 pk-client-error-quark: The following packages have unmet dependencies:
  nvidia-340: Depends: lib32gcc-s1 but it is not going to be installed
              Depends: libc6-i386 but it is not going to be installed (268)
```
then re-attempt the installation like below from the terminal

`sudo ubuntu-drivers autoinstall`

This will give the same errors as in the GUI, but with the version of the package it is expecting. In this case 2.31-0ubuntu9.2 (For e.g. downgrade from 2.31-0ubuntu9.3). Install those specific version of the package like below.

`sudo apt-get install libc6=2.31-0ubuntu9.2 libc-bin=2.31-0ubuntu9.2`

`sudo apt-get install libc6-i386`
 
And then re-attempt the driver installation

`sudo ubuntu-drivers autoinstall`

`sudo apt-get update`

Reference https://askubuntu.com/questions/1315906/unmet-dependencies-libc6-the-package-system-is-broken

 
### NVRM VGA errors in dmesg
Execute `dmesg | grep NVRM` and see if you get the errors below

```
[   17.214717] NVRM: Your system is not currently configured to drive a VGA console
[   17.214720] NVRM: on the primary VGA device. The NVIDIA Linux graphics driver
[   17.214723] NVRM: requires the use of a text-mode VGA console. Use of other console
[   17.214726] NVRM: drivers including, but not limited to, vesafb, may result in
[   17.214729] NVRM: corruption and stability problems, and is not supported.
```
Then edit the `/etc/default/grub` file and add kernel parameters to the line

`GRUB_CMDLINE_LINUX="video=vesa:off vga=normal"` and execute
 
`sudo update-grub`
 
### Disable NVIDIA Splash screen
 
Execute `sudo nvidia-xconfig --no-logo` to disable NVIDIA Splash screen and `sudo nvidia-xconfig --logo` to enable it back again if needed


 
# Regular Cleanup
Periodically run the `CleanCacheAndLogs.sh` as root if you have low root disk space popup appearing in ubuntu (Unity) or gnome. See example images for these pop-up.
Not having enough space for root may even stop your system from booting up (will not load X)

![Alt text](low_root_disk_space_popup_gnome.png "Example message from gnome UI")

![Alt text](low_root_disk_space_popup_ubuntu.png "Example message from Ubuntu UI")
