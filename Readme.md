# Speeding up the boot process
Run [DisableUnnecessaryServices.sh](DisableUnnecessaryServices.sh) to disable `NetworkManager-wait-online.service` , `plymouth-quit-wait.service` , `ModemManager.service` , `ofono.service` & `dundee.service` (IF ofono is installed). Instead of disabling `plymouth-quit-wait.service`, it's even better to purge plymouth with `sudo apt-get purge plymouth`

1.  `sudo nano /etc/default/grub`
2.  Uncomment this line and remove `splash`. i.e. `#GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"` to `GRUB_CMDLINE_LINUX_DEFAULT="quiet"` 
3.  And run `sudo update-grub`

## udisks2 raid warnings

Check if there are any warnings (or error messages) from udisks2 about raid (such as here https://bugs.launchpad.net/ubuntu/+source/udisks2/+bug/1811724) by executing

 `journalctl -b | grep udisks` or `sudo systemctl status udisks2`

If there are messages like "failed to load module mdraid: libbd_mdraid.so.2: cannot open shared object file: No such file or directory" or "Failed to load the 'mdraid' libblockdev plugin", then install the 2 missing packages
 
`sudo apt-get install libblockdev-crypto2 libblockdev-mdraid2`
 
Restart udisks2 and check its status to see if the warnings are gone
 
`sudo systemctl restart udisks2`
 
`journalctl -b | grep udisks` or `sudo systemctl status udisks2`

## Bluetooth

[Blueman related](bluetooth.md) - if blueman prompts every user to authenticate with sudo privilleges upon login

## Allow multicast incoming pings / packets from your router if you use UFW

Add the following rules. `192.168.254.1` is an example of the router's IP address

`sudo ufw allow in from 192.168.254.1 to 224.0.0.0/24` - Refer - [UFW BLOCK messages in dmesg - trouble figuring them out](https://bbs.archlinux.org/viewtopic.php?id=212452) or [Avoid filling up syslog with useless firewall messages](https://forums.linuxmint.com/viewtopic.php?t=111630) or [ufw is blocking mDNS (Bonjour)](https://forums.linuxmint.com/viewtopic.php?t=219396)

Then reload the firewall

`sudo ufw reload`

and check the status

`sudo ufw status verbose`


## Create account agnostic mount points

Follow the steps in [Create common mount points for partitions shared by all users and include them in fstab](common-mountpoints.md)

## Remove snapd

**First** [install firefox from PPA](Firefox-from-PPA.md) **and then** [remove snapd completely](why-not-snapd.md)

## Only for Dell Inspiron 1720 with NVIDIA G86M [GeForce 840M GS] Graphics card

[Handling NVIDIA G86M on Dell Inspiron 1720](Inspiron-1720-NVIDIA-G86M.md)
 
 
## Only for Dell Inspiron 3542 
[Dell Inspiron 3542](Inspiron-3542.md)

 
 
# Regular Cleanup
Periodically run the `DiskSpaceJanitor.sh` (formerly `CleanCacheAndLogs.sh` & `CleanCacheLogsSnaps.sh`) as root if you have low root disk space popup appearing in ubuntu (Unity) or gnome. See example images for these pop-up.
Not having enough space for root may even stop your system from booting up (will not load X)

![Alt text](low_root_disk_space_popup_gnome.png "Example message from gnome UI")

![Alt text](low_root_disk_space_popup_ubuntu.png "Example message from Ubuntu UI")
