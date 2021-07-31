# Taking backups

## Backup the following
1. `/home/<username>` folders of each user who needs to be restored post reinstallation. Ensure that they include the respective .bash_rc and .profile files
2. `/etc/default/grub`
3. `/etc/fstab`

## Users' UIDs and their groups. 

1. Get the groups that each user belongs to, as well their UIDs. Copy the outputs of the following commands in a text file for access post reinstallationThis is need to recreate in them in the same order after reinstallation

`groups firstuser # This is the super user. Output needs to show sudo as a group that this user belongs to`

`id firstuser`

`groups seconduser # This is a non super user. Output does not show sudo as a group that this user belongs to`

`id seconduser`

## Take a list of packages installed before proceeding with reinstallation

`sudo dpkg-query --list >> System-Backup-dpkg-query_list.txt`

# Installing new Lubuntu from USB Start-up disk

## Get USB Start-up disk ready
1. Download the .iso image of Lubuntu 20.04.2 64 bit
2. Verify its check sum `sha256sum ./Downloads/lubuntu-20.04.2-desktop-amd64.iso`
3. Create a start up USB disk with the .iso image using `Startup Disk Creator` in `System tools`

## Installing
1. Boot from USB Start-up disk
2. Install "/" (root) in the same partition as before and also format it at the same time
3. For "/home", select the same partition (mount point) as before but DO NOT format it 
4. Provide the name of the PC and the firstuser EXACTLY as the previous installation

# Post re-installation begins here

## FIRST and FOREMOST
1. Update all drivers from GUI or with `sudo ubuntu-drivers autoinstall`
2. Then perform the update prompted in the GUI soon after restart or with `sudo apt update && sudo apt upgrade`

## Purge unnecessary packages and disable unnecessary services
1. `sudo apt-get purge plymouth snapd` 
2. `sudo systemctl stop NetworkManager-wait-online.service ModemManager.service ofono.service dundee.service` 
3. `sudo systemctl disable NetworkManager-wait-online.service ModemManager.service ofono.service dundee.service`
4. `uname -a # Check distribution and kernel`


## Include swap and other partitions in fstab
1. `blkid # Get UUIDs of all partitions`
2. `sudo mkdir /media/all-users-nextcloud-data # Create user agnostic mount points for each`
3. `sudo mkdir /media/all-users-commondata # Create user agnostic mount points for each`
4. `sudo mkdir /media/all-users-vault # Create user agnostic mount points for each`
5. `sudo nano /etc/fstab # Include UUID of Swap partition and then the UUIDs and mount points for each user agnostic partition above`
6. `sudo mount -a # Check if the edits are good`
7. `swapon # Turn on Swap`

## Fix udisks2 raid warnings
1. `journalctl -b | grep udisks`
2. `sudo apt-get install libblockdev-crypto2 libblockdev-mdraid2`
3. `sudo systemctl status udisks2`
4. `sudo systemctl restart udisks2`
5. `sudo systemctl status udisks2`
6. `journalctl -b | grep udisks`

## Remove NVIDIA Splash logo
`sudo nvidia-xconfig --no-logo`

## Update grub to avoid splash, suppress NVRM VGA dmesg warnings and then use audio from USB webcam 
1. `sudo nano /etc/default/grub #edit GRUB_CMDLINE_LINUX_DEFAULT="quiet usbcore.autosuspend=-1" GRUB_CMDLINE_LINUX="video=vesa:off vga=normal"`
2. `sudo update-grub`

## Upgrade to libreoffice 7-0-6 
1. `sudo add-apt-repository ppa:libreoffice/libreoffice-7-0`
2. `sudo apt full-upgrade`

## Support for typing in multiple languages if needed
1. Refer [Installing Phonetic Keyboards](Phonetic Keyboards.md) 

## Install zoom and signal if needed
1. `sudo dpkg -i ./Downloads/zoom_amd64_5-7-4.deb`
2. `wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg`
3. `echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |sudo tee -a /etc/apt/sources.list.d/signal-xenial.list`
4. `sudo apt update && sudo apt install signal-desktop`

 
 
## Create the second user
### Use the same username as the previous installation 
1. `useradd seconduser`
2. `sudo useradd seconduser # It might be better to use adduser command. But useradd worked here.`
3. `sudo passwd seconduser`
4. `sudo chsh -s /bin/bash seconduser # Set bash as the shell for the second user too`

### Add the second user to group of the first user to share common files
`sudo gpasswd -a seconduser firstuser` 

## Bluetooth applet that supports receiving files
1. `sudo apt-get remove bluedevil`
2. `sudo apt-get install blueman`
3. `systemctl status blueman-mechanism.service # Check for 'gtk_icon_theme_get_for_screen: assertion 'GDK_IS_SCREEN (screen)' failed'` Note: The service might have already failed to start.
4. `sudo systemctl stop blueman-mechanism.service # Stop if for 'gtk_icon_theme_get_for_screen: assertion 'GDK_IS_SCREEN (screen)' failed' is present`
5. `sudo systemctl disable blueman-mechanism.service # Disable` Note: The service will still try to start and give the same error. But it will not hold up the boot process like before.
6. `sudo gpasswd -a seconduser netdev # Add the second user to netdev group to avoid blueman authentication prompts if seen`

 
## Preferred PDF viewer
1. `sudo apt-get install okular`
2. `sudo apt-get purge qpdfview`

 

## jbig2 encoding
Use the commands in the script [Install JBIG2ENC](install-jbig2enc.sh) one by one

## ocrmypdf 
Use the commands in the script [Install OCRMYPDF](install-ocrmypdf.sh) one by one

## Install JRE 16 for all purposes. And also install pdftk ======================
 
1. `sudo apt install openjdk-16-jre-headless`
2. `java -version # Check the installed / active version`
3. `update-alternatives --list java # Remove any versions other than 16 if present`

## Install PDFTK
`sudo apt install pdftk`



## Clean up all lint
Use the script [CleanCacheLogsSnaps.sh](CleanCacheLogsSnaps.sh) to clean up all lint




## Do a hard restart and check the time taken

### ====================== Boot Time below ======================
```

firstuser@firstuser-inspiron1720:~$ systemd-analyze time
Startup finished in 4.619s (kernel) + 11.798s (userspace) = 16.418s 
graphical.target reached after 11.616s in userspace


firstuser@firstuser-inspiron1720:~$ systemd-analyze critical-chain 
The time when unit became active or started is printed after the "@" character.
The time the unit took to start is printed after the "+" character.

graphical.target @11.616s
└─udisks2.service @9.877s +1.737s
  └─basic.target @9.507s
    └─sockets.target @9.507s
      └─uuidd.socket @9.507s
        └─sysinit.target @9.468s
          └─haveged.service @9.467s
            └─apparmor.service @8.492s +970ms
              └─local-fs.target @8.488s
                └─home.mount @8.471s +16ms
                  └─systemd-fsck@dev-disk-by\x2duuid-ffc6e43d\x2d06d8\x2d4499\x2db3f8\x2d45730e965e33.service @7.376s +1.091s
                    └─dev-disk-by\x2duuid-ffc6e43d\x2d06d8\x2d4499\x2db3f8\x2d45730e965e33.device @7.373s


firstuser@firstuser-inspiron1720:~$ systemd-analyze blame 
6.849s dev-sda1.device                                                                          
4.086s systemd-journal-flush.service                                                            
4.059s systemd-udevd.service                                                                    
1.737s udisks2.service                                                                          
1.338s blueman-mechanism.service                                                                
1.290s upower.service                                                                           
1.240s accounts-daemon.service                                                                  
1.188s networkd-dispatcher.service                                                              
1.091s systemd-fsck@dev-disk-by\x2duuid-ffc6e43d\x2d06d8\x2d4499\x2db3f8\x2d45730e965e33.service
 970ms apparmor.service                                                                         
 708ms avahi-daemon.service                                                                     
 682ms bluetooth.service                                                                        
 676ms systemd-journald.service                                                                 
 629ms NetworkManager.service                                                                   
 619ms dev-disk-by\x2duuid-e5367b61\x2d1c1b\x2d4379\x2db0a2\x2d2c5b4bc981dd.swap                
 599ms keyboard-setup.service                                                                   
 567ms apport.service                                                                           
 560ms systemd-logind.service                                                                   
 539ms systemd-udev-trigger.service                                                             
 478ms alsa-restore.service                                                                     
 428ms systemd-rfkill.service                                                                   
 408ms systemd-resolved.service                                                                 
 402ms grub-common.service                                                                      
 391ms user@1000.service                                                                        
 375ms thermald.service                                                                         
 358ms wpa_supplicant.service                                                                   
 340ms kerneloops.service                                                                       
 337ms gpu-manager.service                                                                      
 328ms e2scrub_reap.service                                                                     
 281ms systemd-timesyncd.service                                                                
 255ms rsyslog.service                                                                          
 222ms polkit.service                                                                           
 198ms lvm2-monitor.service                                                                     
 198ms pppd-dns.service                                                                         
 196ms systemd-modules-load.service                                                             
 162ms dev-hugepages.mount                                                                      
 159ms dev-mqueue.mount              

```
