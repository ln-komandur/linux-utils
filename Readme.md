# Speeding up the boot process
Run `DisableUnnecessaryServices.sh` to disable `NetworkManager-wait-online.service` , `plymouth-quit-wait.service` , `ModemManager.service` , `ofono.service` (IF Installed)

Remove `splash` in this line in `/etc/default/grub` and `usbcore.autosuspend=-1` to make the mic in the USB Web Cam work

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

View blueman.rules with

`$ cat /usr/share/polkit-1/rules.d/blueman.rules`

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

`$ groups`

If not, include them in `netdev` group by executing

`sudo gpasswd -a ${USER} netdev` and check again by executing `groups`


## Allow multicast incoming pings / packets from your router if you use UFW

Add the following rule where `192.168.254.1` is an example of your router's IP address

`sudo ufw allow in from 192.168.254.1 to 224.0.0.0/24` - Refer - https://bbs.archlinux.org/viewtopic.php?id=212452 or https://forums.linuxmint.com/viewtopic.php?t=111630

Then reload the firewall

`sudo ufw reload`

and check the status

`sudo ufw status verbose`

# Regular Cleanup
Periodically run the `CleanCacheAndLogs.sh` as root if you have low root disk space popup appearing in ubuntu (Unity) or gnome. See example images for these pop-up.
Not having enough space for root may even stop your system from booting up (will not load X)

![Alt text](low_root_disk_space_popup_gnome.png "Example message from gnome UI")

![Alt text](low_root_disk_space_popup_ubuntu.png "Example message from Ubuntu UI")
