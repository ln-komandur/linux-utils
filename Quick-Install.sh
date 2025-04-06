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

echo "AUTHENTICATION SUCCESSFUL. You are executing the script as" $USER
echo
echo
echo "---------------------------------------------------------------------------------------------------"
echo "UPDATING ALL APPLICABLE DRIVERS"
echo "ubuntu-drivers autoinstall"
echo "---------------------------------------------------------------------------------------------------"

ubuntu-drivers autoinstall

echo
echo
echo "---------------------------------------------------------------------------------------------------"
echo "PURGING (1) PLYMOUTH (2) SNAPD (3) BLUEDEVIL (4) QPDFVIEW (5) 2048-QT (6) ModemManager"
echo "apt-get purge plymouth snapd bluedevil qpdfview 2048-qt modemmanager"
echo "---------------------------------------------------------------------------------------------------"

apt-get purge plymouth snapd bluedevil qpdfview 2048-qt modemmanager

echo
echo
echo "---------------------------------------------------------------------------------------------------"
echo "STOPPING SERVICES (1) NetworkManager-wait-online (2) ofono (3) dundee (4) blueman-mechanism"
echo "systemctl stop NetworkManager-wait-online.service ofono.service dundee.service blueman-mechanism.service"
echo "---------------------------------------------------------------------------------------------------"

systemctl stop NetworkManager-wait-online.service ofono.service dundee.service blueman-mechanism.service

echo
echo
echo "---------------------------------------------------------------------------------------------------"
echo "DISABLING SERVICES (1) NetworkManager-wait-online (2) ofono (3) dundee (4) blueman-mechanism"
echo "systemctl disable NetworkManager-wait-online.service ofono.service dundee.service blueman-mechanism.service"
echo "---------------------------------------------------------------------------------------------------"

systemctl disable NetworkManager-wait-online.service ofono.service dundee.service blueman-mechanism.service

echo
echo
echo "---------------------------------------------------------------------------------------------------"
echo "PLEASE CHECK WARNINGS"
echo "systemctl status udisks2"
echo "---------------------------------------------------------------------------------------------------"

systemctl status udisks2

while true; do
    read -p "DO YOU SEE WARNINGS ON mdraid: libbd_mdraid.so.2, 'mdraid' libblockdev plugin? (Y/N)" yn
    case $yn in
        [Yy]* ) echo "INSTALLING libblockdev-crypto2 libblockdev-mdraid2"; 
                apt-get install libblockdev-crypto2 libblockdev-mdraid2; 
                echo "RESTARTING udisks2"; 
                systemctl restart udisks2; 
                break;;
        [Nn]* ) echo "NOT installing libblockdev-crypto2 libblockdev-mdraid2";
                break;;
        * ) echo "Please answer Y or N.";;
    esac
done


echo
echo
echo "---------------------------------------------------------------------------------------------------"
echo "INSTALLING GAMES - (1) KSUDOKU (2) KPAT (CARD GAME) (3) KMAHJONGG (4) KNIGHTS (CHESS)"
echo "apt-get install ksudoku kpat kmahjongg knights"
echo "---------------------------------------------------------------------------------------------------"

apt-get install ksudoku kpat kmahjongg knights 


echo
echo
echo "---------------------------------------------------------------------------------------------------"
echo "INSTALLING OKULAR"
echo "apt-get install okular"
echo "---------------------------------------------------------------------------------------------------"

apt-get install okular 

echo
echo
echo "---------------------------------------------------------------------------------------------------"
echo "DOING FULL-UPGRADE"
echo "apt full-upgrade"
echo "---------------------------------------------------------------------------------------------------"

apt full-upgrade

echo
echo
echo "Exit"
exit
