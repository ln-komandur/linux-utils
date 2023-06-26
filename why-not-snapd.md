
## Why not snapd?
1. snapd creates loop devices for each application / package it installs. Each of those loop devices are mounted separately during boot up, slowing down the boot up itself.
2. Disabled (unused) snap packages continue to linger around and hog disk space in the root partition unless they are purged explicitly. Over time, on systems with smaller root partitions, these even block the booting itself.

### Recommendation on snapd
1. Stay away from snaps as much as possible on low end systems. Or maintain them regularly (by removing disabled snaps e.t.c) if the system configuration can afford the inefficiences.

## Removing snapd

### References 

https://ubuntuhandbook.org/index.php/2022/04/remove-snap-block-ubuntu-2204/

https://www.debugpoint.com/remove-snap-ubuntu/
 
https://haydenjames.io/remove-snap-ubuntu-22-04-lts/

https://onlinux.systems/guides/20220524_how-to-disable-and-remove-snap-on-ubuntu-2204

## Happy Scenario
Download and execute [Purge-snapd-install-apt-equivalents.sh](Purge-snapd-install-apt-equivalents.sh) to purge snapd completely along with all installed snaps, and install Gnome software and Firefox from apt.

##  Alternative Scenarios
### List all installed snap applications. 

Remember to install them packages as needed after removing snap using deb or apt

`snap list` #Display the list of snaps

or

`snap list >> ListOfInstalledSnaps.txt` #Saves the list of snaps in a text file ListOfInstalledSnaps.txt

### Try method 1 - Remove all snaps in one go

`sudo apt-get purge snapd` #Remove the daemon with apt and remove all apps in one go

Refer below on **binding mounts** if running into problems. Try method 2 if method 1 still doesn't work. 

### Method 2 - Remove each snap app one by one

`sudo systemctl disable snapd.service snapd.socket snapd.seeded.service` **#Disable snapd services**

Remove packages one by one beginning with the least dependent ones

`sudo snap remove --purge <each package in the list>`

For e.g.

`sudo snap remove --purge gnome-3-38-2004`

`sudo snap remove --purge gtk-common-themes`

`sudo snap remove --purge snap-store`

`sudo snap remove --purge snapd-desktop-integration`

`sudo snap remove --purge core20`

`sudo snap remove --purge bare`

`sudo apt remove --autoremove snapd or sudo apt autoremove --purge snapd` **#Remove the daemon with apt**

Refer below on **binding mounts** if running into problems. You may be required to change the order of commands based on where you are at.

### Running into problems
#### Binding mounts

Snap might have created a binding mount point  for hunspell for firefox  at root as described [here](https://askubuntu.com/questions/1431815/lsblk-root-partition-mounted-on-and-var-snap-firefox-common-host-hunspell) and [here](https://ubuntuforums.org/showthread.php?t=2479504&page=2&s=e77435414d5c73db7de789c3ec30e7ff). [See kpa's post on 1 Sep 22](https://forum.snapcraft.io/t/sdb5-mounted-on-firefox/31897/2), alluding to _/etc/systemd/system/var-snap-firefox-common-host\x2dhunspell.mount_ as the source of the binding mount, its contents on the where, the what etc.

`cat /etc/systemd/system/var-snap-firefox-common-host\\x2dhunspell.mount` #View the file that creates the binding mount

`cat /etc/systemd/system/var-snap-firefox-common-host\\x2dhunspell.mount >> ./Desktop/mount-file.txt` #Backup the file

`ls -l /etc/systemd/system/var-snap-firefox-common-host\\x2dhunspell.mount` #Look at its permissions 

`sudo rm -rf /etc/systemd/system/var-snap-firefox-common-host\\x2dhunspell.mount` #Delete the file that creates the binding mount

`sudo umount /var/snap/firefox/common/host-hunspell` #Unmount the mount point

`sudo rm -i /etc/systemd/system/snapd.mounts.target.wants/var-snap-firefox-common-host\\x2dhunspell.mount` #Delete a lingering link. This step may need to be done after the snap purge (not sure).
   
`sudo rmdir /etc/systemd/system/snapd.mounts.target.wants/` #Delete the folder with the lingering link. This step may need to be done after the snap purge (not sure).

Get back to where you left off in method 1 or 2 above. `reboot` #if required and check that the binding mount is gone. 

### Clear leftovers and caches

`sudo rm -rf /var/cache/snapd/` #Delete any leftover cache from Snap

`rm -rf ~/snap` #Remove snap directory where apps were installed and your personal settings for them stored

### Prevent ubuntu from installing snap package again

After completely removing snap packages, set a low priority for the snapd package to prevent Ubuntu from reinstalling it.

Copy and Paste the following lines as a whole, not line by line
```
echo '
# Prevent repository packages from triggering the installation of snap,
# Forbids snapd from being installed by APT by using  Pin-Priority: -10

Package: snapd
Pin: release a=*
Pin-Priority: -10
' sudo tee /etc/apt/preferences.d/nosnap.pref
```

`sudo apt update` #Refresh package cache

### Install Gnome Software in place of Snap Store (Ubuntu Software) 

`sudo apt install gnome-software` #Do not use any switches like --install-suggests or --install-recommends
