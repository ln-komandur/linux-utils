# Taking backups

## Backup the following
1. `/home/<username>` folders of each user who needs to be restored post reinstallation. Ensure that they include the respective .bash_rc and .profile files
2. `/etc/default/grub`
3. `/etc/fstab`

## Users' UIDs and their groups. 

1. Get the groups that each user belongs to, as well their UIDs. Copy the outputs of the following commands in a text file for access post reinstallationThis is need to recreate in them in the same order after reinstallation

`firstuser@firstuser-pcname:~$ groups firstuser # This is the super user. Output needs to show sudo as a group that this user belongs to`

`firstuser@firstuser-pcname:~$ id firstuser`

`firstuser@firstuser-pcname:~$ groups seconduser # This is a non super user. Output does not show sudo as a group that this user belongs to`

`firstuser@firstuser-pcname:~$ id seconduser`

## Take a list of packages installed before proceeding with reinstallation

`firstuser@firstuser-pcname:~$ sudo dpkg-query --list >> System-Backup-dpkg-query_list.txt`

# Installing new Lubuntu from USB Start-up disk

## Get USB Start-up disk ready
1. Download the .iso image of Lubuntu 20.04.2 64 bit
2. Verify its check sum `firstuser@firstuser-pcname:~$ sha256sum ./Downloads/lubuntu-20.04.2-desktop-amd64.iso`
3. Create a start up USB disk with the .iso image using `Startup Disk Creator` in `System tools`

## Installing
1. Boot from USB Start-up disk
2. Install "/" (root) in the same partition as before and also format it at the same time
3. For "/home", select the same partition (mount point) as before but DO NOT format it 
4. Provide the name of the PC and the firstuser EXACTLY as the previous installation

# Post re-installation begins here

## FIRST and FOREMOST
1. Update all drivers from GUI or with `firstuser@firstuser-pcname:~$ sudo ubuntu-drivers autoinstall`
2. Then perform the update prompted in the GUI soon after restart or with `firstuser@firstuser-pcname:~$ sudo apt update && sudo apt upgrade`

## Purge unnecessary packages and disable unnecessary services
1. `firstuser@firstuser-pcname:~$ sudo apt-get purge plymouth snapd` 
2. `firstuser@firstuser-pcname:~$ sudo systemctl stop NetworkManager-wait-online.service ModemManager.service ofono.service dundee.service` 
3. `firstuser@firstuser-pcname:~$ sudo systemctl disable NetworkManager-wait-online.service ModemManager.service ofono.service dundee.service`
4. `firstuser@firstuser-pcname:~$ uname -a # Check distribution and kernel`


## Include swap and other partitions in fstab
1. `firstuser@firstuser-pcname:~$ blkid # Get UUIDs of all partitions`
2. `firstuser@firstuser-pcname:~$ sudo mkdir /media/all-users-nextcloud-data # Create user agnostic mount points for each`
3. `firstuser@firstuser-pcname:~$ sudo mkdir /media/all-users-commondata # Create user agnostic mount points for each`
4. `firstuser@firstuser-pcname:~$ sudo mkdir /media/all-users-vault # Create user agnostic mount points for each`
5. `firstuser@firstuser-pcname:~$ sudo nano /etc/fstab # Include UUID of Swap partition and then the UUIDs and mount points for each user agnostic partition above`
6. `firstuser@firstuser-pcname:~$ sudo mount -a # Check if the edits are good`
7. `firstuser@firstuser-pcname:~$ swapon # Turn on Swap`

## Fix udisks2 raid warnings
1. `firstuser@firstuser-pcname:~$ journalctl -b | grep udisks`
2. `firstuser@firstuser-pcname:~$ sudo apt-get install libblockdev-crypto2 libblockdev-mdraid2`
3. `firstuser@firstuser-pcname:~$ sudo systemctl status udisks2`
4. `firstuser@firstuser-pcname:~$ sudo systemctl restart udisks2`
5. `firstuser@firstuser-pcname:~$ sudo systemctl status udisks2`
6. `firstuser@firstuser-pcname:~$ journalctl -b | grep udisks`

## Remove NVIDIA Splash logo
`firstuser@firstuser-pcname:~$ sudo nvidia-xconfig --no-logo`

## Update grub to avoid splash, suppress NVRM VGA dmesg warnings and then use audio from USB webcam 
1. `firstuser@firstuser-pcname:~$ sudo nano /etc/default/grub #edit GRUB_CMDLINE_LINUX_DEFAULT="quiet usbcore.autosuspend=-1" GRUB_CMDLINE_LINUX="video=vesa:off vga=normal"`
2. `firstuser@firstuser-pcname:~$ sudo update-grub`

## Upgrade to libreoffice 7-0-6 
1. `firstuser@firstuser-pcname:~$ sudo add-apt-repository ppa:libreoffice/libreoffice-7-0`
2. `firstuser@firstuser-pcname:~$ sudo apt full-upgrade`

## Support for typing in multiple languages if needed
1. Refer [Installing Phonetic Keyboards](Phonetic Keyboards.md) 

## Install zoom and signal if needed
1. `firstuser@firstuser-pcname:~$ sudo dpkg -i ./Downloads/zoom_amd64_5-7-4.deb`
2. `firstuser@firstuser-pcname:~$ wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg`
3. `firstuser@firstuser-pcname:~$ echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |sudo tee -a /etc/apt/sources.list.d/signal-xenial.list`
4. `firstuser@firstuser-pcname:~$ sudo apt update && sudo apt install signal-desktop`

 
 
## Create the second user
### Use the same username as the previous installation 
1. `firstuser@firstuser-pcname:~$ useradd seconduser`
2. `firstuser@firstuser-pcname:~$ sudo useradd seconduser # It might be better to use adduser command. But useradd worked here.`
3. `firstuser@firstuser-pcname:~$ sudo passwd seconduser`
4. `firstuser@firstuser-pcname:~$ sudo chsh -s /bin/bash seconduser # Set bash as the shell for the second user too`

### Add the second user to group of the first user to share common files
`firstuser@firstuser-pcname:~$ sudo gpasswd -a seconduser firstuser` 

## Bluetooth application with more functionality
1. `firstuser@firstuser-pcname:~$ sudo apt-get remove bluedevil`
2. `firstuser@firstuser-pcname:~$ sudo apt-get install blueman`
3. `firstuser@firstuser-pcname:~$ systemctl status blueman-mechanism.service # Check for 'gtk_icon_theme_get_for_screen: assertion 'GDK_IS_SCREEN (screen)' failed'`
4. `firstuser@firstuser-pcname:~$ sudo systemctl stop blueman-mechanism.service # Stop if for 'gtk_icon_theme_get_for_screen: assertion 'GDK_IS_SCREEN (screen)' failed' is present`
5. `firstuser@firstuser-pcname:~$ sudo systemctl disable blueman-mechanism.service # Disable
6. `firstuser@firstuser-pcname:~$ sudo gpasswd -a seconduser netdev # Add the second user to netdev group to avoid blueman authentication prompts if seen`

 
## Preferred PDF viewer
1. `firstuser@firstuser-pcname:~$ sudo apt-get install okular`
2. `firstuser@firstuser-pcname:~$ sudo apt-get purge qpdfview`

 

## jbig2 encoding
Use the commands in the script [Install JBIG2ENC](install-jbig2enc.sh) one by one

## ocrmypdf 
Use the commands in the script [Install OCRMYPDF](install-ocrmypdf.sh) one by one

## Install JRE 16 for all purposes. And also install pdftk ======================
 
1. `firstuser@firstuser-pcname:~$ sudo apt install openjdk-16-jre-headless`
2. `firstuser@firstuser-pcname:~$ java -version # Check the installed / active version`
3. `firstuser@firstuser-pcname:~$ update-alternatives --list java # Remove any versions other than 16 if present`

## Install PDFTK
`firstuser@firstuser-pcname:~$ sudo apt install pdftk`



## Clean up all lint
Use the script [CleanCacheLogsSnaps.sh](CleanCacheLogsSnaps.sh) to clean up all lint




## Do a hard restart and check the time taken

### ====================== Boot Time below ======================
```

firstuser@firstuser-inspiron1720:~$ systemd-analyze time
Startup finished in 4.548s (kernel) + 15.691s (userspace) = 20.240s 
graphical.target reached after 15.488s in userspace


firstuser@firstuser-inspiron1720:~$ systemd-analyze critical-chain 
The time when unit became active or started is printed after the "@" character.
The time the unit took to start is printed after the "+" character.

graphical.target @15.488s
└─multi-user.target @15.488s
  └─blueman-mechanism.service @4.469s +11.018s
    └─basic.target @4.375s
      └─sockets.target @4.375s
        └─uuidd.socket @4.375s
          └─sysinit.target @4.347s
            └─systemd-timesyncd.service @3.606s +740ms
              └─systemd-tmpfiles-setup.service @3.464s +118ms
                └─local-fs.target @3.418s
                  └─home.mount @3.389s +28ms
                    └─systemd-fsck@dev-disk-by\x2duuid-ffc6e43d\x2d06d8\x2d4499\x2db3f8\x2d45730e965e33.service @3.261s +114ms
                      └─dev-disk-by\x2duuid-ffc6e43d\x2d06d8\x2d4499\x2db3f8\x2d45730e965e33.device @3.182s


firstuser@firstuser-inspiron1720:~$ systemd-analyze blame 
11.018s blueman-mechanism.service                                                                
10.301s man-db.service                                                                           
10.296s udisks2.service                                                                          
 3.068s logrotate.service                                                                        
 2.550s dev-sda1.device                                                                          
 2.118s accounts-daemon.service                                                                  
 1.862s networkd-dispatcher.service                                                              
 1.580s systemd-logind.service                                                                   
 1.381s avahi-daemon.service                                                                     
 1.378s upower.service                                                                           
 1.331s apport.service                                                                           
 1.233s NetworkManager.service                                                                   
 1.178s bluetooth.service                                                                        
 1.080s gpu-manager.service                                                                      
  827ms wpa_supplicant.service                                                                   
  757ms thermald.service                                                                         
  747ms alsa-restore.service                                                                     
  740ms systemd-timesyncd.service                                                                
  737ms systemd-resolved.service                                                                 
  706ms grub-common.service                                                                      
  694ms systemd-rfkill.service                                                                   
  687ms systemd-journald.service                                                                 
  685ms apparmor.service                                                                         
  594ms keyboard-setup.service                                                                   
  580ms systemd-udev-trigger.service                                                             
  482ms polkit.service                                                                           
  445ms e2scrub_reap.service                                                                     
  423ms kerneloops.service                                                                       
  410ms rsyslog.service                                                                          
  388ms user@1000.service                                                                        
  309ms grub-initrd-fallback.service                                                             
  302ms systemd-journal-flush.service                                                            
  286ms pppd-dns.service                                                                         
  278ms systemd-udevd.service                                                                    
  213ms lvm2-monitor.service                                                                     
  180ms systemd-modules-load.service                                                             
  153ms dev-mqueue.mount             

```
