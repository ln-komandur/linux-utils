#!/bin/bash
#ref: https://unix.stackexchange.com/questions/28791/prompt-for-sudo-password-and-programmatically-elevate-privilege-in-bash-script
#ref: https://askubuntu.com/a/30157/8698

if (($EUID != 0)); then
  if [[ -t 1 ]]; then
#https://unix.stackexchange.com/questions/218715/what-does-t-1-do
    sudo "$0" "$@"
  else
    exec 1>output_file
    gksu "$0 $@"
  fi
  exit
fi
echo "This script purges snapd completely along with all installed snaps and installs Gnome software and Firefox from apt."
echo
echo

#Remove snapd-firefox hunspell binding mounts
echo
echo Removing snapd-firefox hunspell binding mounts
echo
echo


cat /etc/systemd/system/var-snap-firefox-common-host\\x2dhunspell.mount >> ~/Desktop/mount-file.txt #Backup the file
rm -rf /etc/systemd/system/var-snap-firefox-common-host\\x2dhunspell.mount #Delete the file that creates the binding mount
umount /var/snap/firefox/common/host-hunspell #Unmount the mount point
rm -i /etc/systemd/system/snapd.mounts.target.wants/var-snap-firefox-common-host\\x2dhunspell.mount #Delete a lingering link. This step may need to be done after the snap purge (not sure)
rmdir /etc/systemd/system/snapd.mounts.target.wants/ #Delete the folder with the lingering link. This step may need to be done after the snap purge (not sure)
rm /etc/systemd/system/multi-user.target.wants/var-snap-firefox-common-host\\x2dhunspell.mount #Delete a lingering link.

#Purge the snap daemon with apt and remove all snap apps in one go
echo
echo Purging the snap daemon with apt and remove all snap apps in one go
echo
echo

apt-get purge snapd #Remove the snap daemon with apt and remove all snap apps in one go
rm -rf /var/cache/snapd/ #Delete any leftover cache from Snap
rm -rf ~/snap #Remove snap directory where apps were installed and your personal settings for them stored


#Prevent ubuntu from installing snap package again
echo
echo Preventing ubuntu from installing snap package again
echo
echo
echo '
# Prevent repository packages from triggering the installation of snap,
# Forbids snapd from being installed by APT by using  Pin-Priority: -10

Package: snapd
Pin: release a=*
Pin-Priority: -10
' tee /etc/apt/preferences.d/nosnap.pref

#Add the mozillateam ppa
echo
echo Adding the mozillateam ppa
echo
echo
add-apt-repository ppa:mozillateam/ppa #Add the mozillateam ppa


#Alter the Firefox package priority to ensure the PPA/deb/apt version is preferred
echo
echo Altering the Firefox package priority to ensure the PPA/deb/apt version is preferred
echo
echo

echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | tee /etc/apt/preferences.d/mozilla-firefox


#Refresh the package cache, Install Gnome Software in place of Snap Store (Ubuntu Software), Install firefox from apt
echo
echo Refreshing the package cache, installing Gnome Software in place of Snap Store \(Ubuntu Software\), installing firefox from apt
echo
echo
apt update
apt install gnome-software #Do not use any switches like --install-suggests or --install-recommends
apt purge snapd #Purge snapd again, and the Snap App Index gnome-software-plugin-snap for gnome-software
apt install firefox
