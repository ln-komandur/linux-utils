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

`groups firstuser` #This is the super user. Output needs to show sudo as a group that this user belongs to

`id firstuser`

`groups seconduser` #This is a non super user. Output does not show sudo as a group that this user belongs to

`id seconduser`

## Take a list of packages installed before proceeding with reinstallation

`sudo dpkg-query --list >> System-Backup-dpkg-query_list.txt`

# BIOS

## Latest version
Update to the latest version of BIOS released by the manufacturer. 
1.  For systems that support BIOS updates from within BIOS, e.g. the HP EliteBook 800 G2 DM, connect to the internet via RJ45 and follow the steps from within BIOS
1.  For systems that can run Windows, follow the manufacturer's instructions 
2.  For Linux only systems that **support Legacy boot** (UEFI disabled, Secure boot disbled) use [FreeDOS](http://www.freedos.org/download/)
    1.   Follow the [Update the Dell BIOS in a Linux or Ubuntu environment](https://www.dell.com/support/kbdoc/en-us/000131486/update-the-dell-bios-in-a-linux-or-ubuntu-environment) instructions that use [FreeDOS](http://www.freedos.org/download/). This method worked with Dell Inspirin 3542 (with UEFI) and Dell Inspiron 1720 (without UEFI)
    2.  For all other Linux only systems **try the approach [described here](https://h30434.www3.hp.com/t5/Notebook-Software-and-How-To-Questions/Update-BIOS-on-EliteBook-8560w-running-Linux-using-FreeDOS/td-p/8322446)** using [FreeDOS](http://www.freedos.org/download/) and 7zip (installed with `sudo apt install p7zip-full p7zip-rar`)
        1.  Download the BIOS update file for Windows.
        2.  Extract files from BIOS update exe using 7zip in the terminal with `7z -o/home/user/extracted-bios x path/to/exe-file`
        3.  Copy folder of extracted files called “extracted-bios” onto the FreeDOS USB
        4.  Boot from USB. Select "NO" when prompted to install FreeDOS and continue to DOS.
        5.  At the DOS prompt, list DOS directories with `dir` and change to the directory where the exe file was copied to with `cd extracted-bios`. Execute the .exe file by typing its name on the DOS prompt
3. For HP Systems that do not support legacy boot, use a loaner Windows PC to create a USB recovery disk with the BIOS file for the update as described under [Update the BIOS manually from a USB Flash drive (outside of Windows)](https://support.hp.com/gb-en/document/c00042629) and **try**


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
Refer "Speeding up the boot process" in [Read Me](Readme.md). Install [firefox through apt](Firefox-from-PPA.md), and **then** [remove snaps](why-not-snapd.md) too

1. `sudo apt-get purge plymouth` #Purge plymouth
2. `sudo systemctl stop NetworkManager-wait-online.service ModemManager.service ofono.service dundee.service` 
3. `sudo systemctl disable NetworkManager-wait-online.service ModemManager.service ofono.service dundee.service`
4. `uname -a` #Check distribution and kernel

## Include swap and other partitions in fstab
1. Refer [Create common mount points](common-mountpoints.md) for partitions commonly accessed by all users
2. Remember to include UUID of Swap partition in `/etc/fstab` in the above. Put it after the mount points for "/" (root), "/home" and "tmpfs"
3. `swapon` #Turn on Swap

## Fix udisks2 raid warnings
Refer "udisks2 raid warnings" in [Read Me](Readme.md)

## NVIDIA graphics cards
If using NVIDIA graphics cards [Remove NVIDIA Splash logo / Disable NVIDIA Splash screen](./Inspiron-1720-NVIDIA-G86M.md)

## Update grub to suppress NVRM VGA dmesg warnings 
Refer [Disabling the conflicting vesafb driver](https://newton.freehostia.com/comp/ubstuff.html)
1. `sudo nano /etc/default/grub` #Open grub for edit
2. Edit `GRUB_CMDLINE_LINUX=""` to be `GRUB_CMDLINE_LINUX="video=vesa:off vga=normal"`
3. `sudo update-grub` #Update grub

## Use USB (usually 2.0) webcam audio (mic)

1. `sudo nano /etc/default/grub` #Open grub for edit 
2. Uncomment this line `#GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"`, and add `usbcore.autosuspend=-1` to make the mic in the USB Web Cam work. 
   1.   i.e. `#GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"` to `GRUB_CMDLINE_LINUX_DEFAULT="quiet usbcore.autosuspend=-1"`. In this example, note that `splash` is removed too
3. `sudo update-grub` #Update grub

## Install nala
[nala](https://linuxiac.com/nala-apt-command-frontend/) is an [attractive CLI tool](https://www.omgubuntu.co.uk/2023/01/install-nala-on-ubuntu) to conduct most APT terminal operations

`sudo apt install nala` #Nala is a frontend for APT

## Remove thunderbird
Helps save space and needless updates for those who dont use this app

`sudo apt remove thunderbird` #Save space and needless updates

## Install guvcview and Remove cheese
[guvcview](https://www.omgubuntu.co.uk/2011/02/webcam-linux) provides more options and controls than cheese

`sudo apt install guvcview && sudo apt remove cheese` #Replace cheese with guvcview



## Upgrade to libreoffice 7-0-6 - Lubuntu 20.04
1. `sudo add-apt-repository ppa:libreoffice/libreoffice-7-0`
2. `sudo apt full-upgrade`

## Support for typing in multiple languages if needed
1. Refer [Installing Phonetic Keyboards](Phonetic-Keyboards.md) 

## Install chrome brower through .deb if needed
1. `wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb`  - refer [this link](https://www.wikihow.com/Install-Google-Chrome-Using-Terminal-on-Linux)
2. `sudo dpkg -i google-chrome-stable_current_amd64.deb` - This command will also add the _https://dl.google.com/linux/chrome/deb/_ PPA to Other software 

## Install zoom if needed
1. `sudo dpkg -i ./Downloads/zoom_amd64.deb`
2. `sudo apt --fix-broken install` #to fix libgl1-mesa-glx errors and re-execute the above command if needed
   1. libgl1-mesa-glx errors look like below - refer [this link](https://askubuntu.com/questions/1244720/dependency-errors-while-installing-zoom-on-ubuntu-20-04) 
```
        dpkg: dependency problems prevent configuration of zoom:
         zoom depends on libgl1-mesa-glx; however:
```

## Install signal if needed

1. `wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg`
2. `echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |sudo tee -a /etc/apt/sources.list.d/signal-xenial.list`
3. `sudo apt update && sudo apt install signal-desktop`

## Install flatpak, if you like to

Refer [Managing flatpak apps](flatpak-apps.md)

## Create the second user
### Use the same username as the previous installation 
1. `sudo adduser seconduser` #Provide username, password, Name of User, etc. when prompted
2. `sudo chsh -s /bin/bash seconduser` #Set bash as the shell for the second user too

## Bluetooth applet that supports receiving files - Lubuntu 20.04
1. `sudo apt-get remove bluedevil`
2. `sudo apt-get install blueman`
3. Refer "blueman gtk_icon_theme_get_for_screen warnings" in [Bluetooth](bluetooth.md)
4. Add the second user to netdev group to avoid blueman authentication prompts if seen. `sudo gpasswd -a seconduser netdev`. Refer "blueman prompt / error requiring every user to authenticate with sudo privilleges upon login" in [Bluetooth](bluetooth.md)

## Install VLC
1. Install VLC media player through apt by pasting `apt://vlc` in the browser's address bar. Refer here for [more details](https://www.videolan.org/vlc/download-ubuntu.html)
2. `sudo apt-get remove rhythmbox` #Remove rhythmbox if not needed
 
## Preferred PDF viewer
1. `sudo apt-get install okular`
2. `sudo apt-get purge qpdfview` #in Lubuntu

## Games
Install KDE games for Sudoko, Card Games, Mahjongg & Chess in Lubuntu with 

`sudo apt-get install ksudoku kpat kmahjongg knights`

## jbig2 encoding
Use the commands in the script [Install JBIG2ENC](install-jbig2enc.sh) one by one. Install git before that with `sudo apt install git` if it is not already installed

## ocrmypdf 
Use the commands in the script [Install OCRMYPDF](install-ocrmypdf.sh) one by one. Install pip before that with `sudo apt install python3-pip` if it is not already installed

## Install the latest JRE for all purposes. 

If java is not already installed, executing `java -version` will output all versions avalable to install. Pick the latest

1. `sudo apt install openjdk-19-jre-headless` #Latest as of March 2023
2. `java -version` #Check the installed / active version
3. `sudo apt install libreoffice-java-common` #Install the JRE components for libreoffice  
4. `update-alternatives --list java` #Remove any versions other than the latest if present
5. `sudo apt install openjdk-1x-jre-headless` #Replace 1x with the real value. Remove the older version of JRE installed by libreoffice-java-common
6. Select the latest version of JRE in LibreOffice under _"Tools -> Options -> Advanced"_

## Install PDFTK (after JRE)
`sudo apt install pdftk`

## Install Czkawka
### Option 1: 
Click the "Install" button in the table against correct version number of the package at [xtreadeb AptURL](https://xtradeb.net/apps/czkawka/)

### Option 2: 
Using the xtradeb PPA - Debian / Ubuntu (unofficial) - as [described here](https://qarmin.github.io/czkawka/instructions/Installation.html)

`sudo add-apt-repository ppa:xtradeb/apps` #Add the xtradeb unofficial PPA  

This xtradeb PPA would end up providing firefox updates also. So, retrict it [only to czkawka](https://xtradeb.net/wiki/how-to-restrict-which-applications-are-available-to-install/) with

```
sudo tee -a /etc/apt/preferences.d/xtradeb.pref <<EOF
Package: *
Pin: release o=LP-PPA-xtradeb-*
Pin-Priority: -10

Package: czkawka
Pin: release o=LP-PPA-xtradeb-*
Pin-Priority: 999
EOF
```

`sudo apt-get update` #Update the packages

`sudo apt-get install czkawka` #Install czkawka from xtradeb PPA


## Install gparted
Install gparted with

`sudo apt install gparted`

## Clean up all lint
Use the script [DiskSpaceJanitor.sh](DiskSpaceJanitor.sh) (formerly `CleanCacheAndLogs.sh` & `CleanCacheLogsSnaps.sh`) as root to clean up all lint

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
