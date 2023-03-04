
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
 
### Remove each app installed by snap

List all installed snap applications:

`snap list` - Remember to install these packages as needed after removing snap using deb or apt

Disable snapd services with 

`sudo systemctl disable snapd.service snapd.socket snapd.seeded.service`

Remove packages one by one 
 
`sudo snap remove --purge <each package in the list>`

 For e.g. `sudo snap remove --purge firefox` and `sudo snap remove --purge snap-store`
 
Remove the daemon 

`sudo apt remove --autoremove snapd` or `sudo apt autoremove --purge snapd`

Delete any leftover cache from Snap with

`sudo rm -rf /var/cache/snapd/`

`rm -rf ~/snap`

### Prevent ubuntu from installing snap package again

After completely removing snap packages, set a low priority for the snapd package to prevent Ubuntu from reinstalling it

Create and open a configuration file with `sudo gedit /etc/apt/preferences.d/nosnap.pref`

Paste the following lines in the file to prevent the package installation from any repository:
```
    # Prevent repository packages from triggering the installation of snap,
    # Forbids snapd from being installed by APT by using  Pin-Priority: -10

    Package: snapd
    Pin: release a=*
    Pin-Priority: -10
```
Save the file and refresh package cache with `sudo apt update`
