***Note:*** Though originally written with Lubuntu 20.04.2 64 bit in mind, this applies to other Ubuntu variants as well.

# Backup

## Backup the following

**Note:** This is a precautionary step. Restoration of any of these backups is not covered as that need did not arise (knock on good wood)
1. `/home/<username>` folders of each user who needs to be restored post reinstallation. Ensure that they include the respective .bash_rc and .profile files
2. `/etc/default/grub`
3. `/etc/fstab`
4. Export bookmarks from all browsers of all users and take a backup

## Users' UIDs and their groups. 

1. Get the groups that each user belongs to, as well their UIDs. Copy the outputs of the following commands in a text file for access post reinstallation. This is needed to recreate in them in the same order after reinstallation

`groups firstuser # This is the super user. Output needs to show sudo as a group that this user belongs to`

`id firstuser`

`groups seconduser # This is a non super user. Output does not show sudo as a group that this user belongs to`

`id seconduser`

## Take a list of packages installed before proceeding with reinstallation

`sudo dpkg-query --list >> System-Backup-dpkg-query_list.txt`

# BIOS

## Latest version
Update to the latest version of BIOS released by the manufacturer

## Secure boot
Ensure that Legacy boot is disabled (as opposed to UEFI or other EFI boots) and Secure boot is enabled

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
5. If there is any opportunity to format any partitions, ensure they are GPT (not MBR). 
    1. This will most likely be taken care if BIOS is set to Secure (UEFI) boot. 
    1. Master Boot Record (MBR) allows utmost 4 primary partitions or 3 primary partitions plus one extended partitions, which can contain unallocated space within it to create unlimited number of Logical partitions.
    1. Interesting insights about [MBR vs GPT](https://www.makeuseof.com/tag/mbr-vs-gpt/)
    2. Reference - [GParted: Create GPT Partition Step by Step](https://www.diskpart.com/gpt-mbr/gparted-create-gpt-partition-7201.html)
    3. Reference - [No EFI System Partition...](https://askubuntu.com/questions/1128810/no-efi-system-partition-option-for-ubuntu-18-10)
6. Create / resize any swap partitions. Remember to turn them on later. If you not require swap partitions, skip this step
7. Create a separate small partition (could be ~8 to 10GB) for encrpted storage. Veracrypt could be used on this partition 
8. Go through the MOK (Machine-Owned Key) enrollment process

# Post re-installation begins here

## FIRST and FOREMOST
1. Update all drivers from GUI or with `sudo ubuntu-drivers autoinstall`
2. Then perform the update prompted in the GUI soon after restart or with `sudo apt update && sudo apt upgrade`

## Purge unnecessary packages and disable unnecessary services
Refer "Speeding up the boot process" in [Read Me](Readme.md)

1. `sudo apt-get purge plymouth snapd` 
2. `sudo systemctl stop NetworkManager-wait-online.service ModemManager.service ofono.service dundee.service` 
3. `sudo systemctl disable NetworkManager-wait-online.service ModemManager.service ofono.service dundee.service`
4. `uname -a # Check distribution and kernel`


## Include swap and other partitions in fstab
1. Refer "Create common mount points for partitions commonly accessed by all users and include them in fstab." in [Read Me](Readme.md)
2. Remember to include UUID of Swap partition in `/etc/fstab` in the above. Put it after the mount points for "/" (root), "/home" and "tmpfs"
3. `swapon # Turn on Swap`

## Fix udisks2 raid warnings
Refer "udisks2 raid warnings" in [Read Me](Readme.md)

## NVIDIA graphics cards
If using NVIDIA graphics cards [Remove NVIDIA Splash logo / Disable NVIDIA Splash screen](./Inspiron-1720-NVIDIA-G86M.md)

## Update grub to avoid splash, suppress NVRM VGA dmesg warnings and then use audio from USB webcam 
1. `sudo nano /etc/default/grub #edit GRUB_CMDLINE_LINUX_DEFAULT="quiet usbcore.autosuspend=-1" GRUB_CMDLINE_LINUX="video=vesa:off vga=normal"`
2. `sudo update-grub`

## Upgrade to libreoffice 7-0-6 - Lubuntu 20.04
1. `sudo add-apt-repository ppa:libreoffice/libreoffice-7-0`
2. `sudo apt full-upgrade`

## Support for typing in multiple languages if needed
1. Refer [Installing Phonetic Keyboards](Phonetic-Keyboards.md) 

## Install zoom if needed
1. `sudo dpkg -i ./Downloads/zoom_amd64.deb`
2. Use `sudo apt --fix-broken install` to fix the follwing errors and re-execute the above command if needed - refer [this link](https://askubuntu.com/questions/1244720/dependency-errors-while-installing-zoom-on-ubuntu-20-04) 
```
        dpkg: dependency problems prevent configuration of zoom:
         zoom depends on libgl1-mesa-glx; however:
```

## Install signal if needed

1. `wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg`
2. `echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |sudo tee -a /etc/apt/sources.list.d/signal-xenial.list`
3. `sudo apt update && sudo apt install signal-desktop`

## Install flatpak, if you like to
Reference [How to Install Flatpak & Flathub on Ubuntu (Complete Guide)](https://www.omgubuntu.co.uk/how-to-install-flatpak-on-ubuntu)

1.  `sudo apt install flatpak gnome-software-plugin-flatpak gnome-software`
2.  `flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo`
3.  `reboot`

Query and check the installation

4.  `echo $XDG_DATA_DIRS`
5.  `flatpak list` 
6.  `flatpak --version`
7.  `flatpak search postman`
8.  `flatpak search telegram`
9.  `flatpak search libreoffice`

Install flatpak apps from the **Software app** GUI

## Create the second user
### Use the same username as the previous installation 
1. `sudo adduser seconduser # Provide username, password, Name of User, etc. when prompted`
2. `sudo chsh -s /bin/bash seconduser # Set bash as the shell for the second user too`

### Add the second user to group of the first user to share common files
`sudo gpasswd -a seconduser firstuser` 

## Bluetooth applet that supports receiving files - Lubuntu 20.04
1. `sudo apt-get remove bluedevil`
2. `sudo apt-get install blueman`
3. Refer "blueman gtk_icon_theme_get_for_screen warnings" in [Bluetooth](bluetooth.md)
4. Add the second user to netdev group to avoid blueman authentication prompts if seen. `sudo gpasswd -a seconduser netdev`. Refer "blueman prompt / error requiring every user to authenticate with sudo privilleges upon login" in [Bluetooth](bluetooth.md)

## Install VLC
1. Install VLC media player through apt by pasting `apt://vlc` in the browser's address bar. Refer here for [more details](https://www.videolan.org/vlc/download-ubuntu.html)
2. Remove rhythmbox if installed using `sudo apt-get remove rhythmbox`
 
## Preferred PDF viewer
1. `sudo apt-get install okular`
2. `sudo apt-get purge qpdfview` - in Lubuntu

## Games
Install KDE games for Sudoko, Card Games, Mahjongg & Chess in Lubuntu with 

`sudo apt-get install ksudoku kpat kmahjongg knights`

## jbig2 encoding
Use the commands in the script [Install JBIG2ENC](install-jbig2enc.sh) one by one. Install git before that with `sudo apt install git` if it is not already installed

## ocrmypdf 
Use the commands in the script [Install OCRMYPDF](install-ocrmypdf.sh) one by one. Install pip before that with `sudo apt install python3-pip` if it is not already installed

## Install the latest JRE for all purposes. 

If java is not already installed, executing `java -version` will output all versions avalable to install. Pick the latest

1. `sudo apt install openjdk-16-jre-headless` or`sudo apt install openjdk-19-jre-headless`
2. `java -version # Check the installed / active version`
3. `update-alternatives --list java # Remove any versions other than the latest if present`

## Install PDFTK (after JRE)
`sudo apt install pdftk`

## Install Czkawka
Install Czkawka 
1. from https://xtradeb.net/apps/czkawka/ from AptURL as found on https://qarmin.github.io/czkawka/instructions/Installation.html 
2. or using PPA - Debian / Ubuntu (unofficial) - also found on https://qarmin.github.io/czkawka/instructions/Installation.html 

```
sudo add-apt-repository ppa:xtradeb/apps
sudo apt-get update
sudo apt-get install czkawka
```

## Install gparted
Install gparted with

`sudo apt install gparted`

## Clean up all lint
Use the script [CleanCacheLogsSnaps.sh](CleanCacheLogsSnaps.sh) to clean up all lint

## Do a hard restart and check the time taken

### ====================== Boot Time below ======================
```

$ systemd-analyze time
Startup finished in 4.619s (kernel) + 11.798s (userspace) = 16.418s 
graphical.target reached after 11.616s in userspace


$ systemd-analyze critical-chain 
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


$ systemd-analyze blame 
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
