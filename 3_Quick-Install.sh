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
echo "INSTALLING nala"
echo "apt install nala"
echo "---------------------------------------------------------------------------------------------------"

apt install nala

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
                apt install libblockdev-crypto2 libblockdev-mdraid2; # Intentionally not used nala. This error occurs in 22.04 and prior. nala is not supported in 20.04 
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
echo "nala / apt install ksudoku kpat kmahjongg knights"
echo "---------------------------------------------------------------------------------------------------"

if ! nala install ksudoku kpat kmahjongg knights; then
    apt install ksudoku kpat kmahjongg knights 
fi 


echo
echo
echo "---------------------------------------------------------------------------------------------------"
echo "INSTALLING OKULAR"
echo "nala / apt install okular"
echo "---------------------------------------------------------------------------------------------------"

if ! nala install okular; then
    apt install okular 
fi 

echo
echo
echo "---------------------------------------------------------------------------------------------------"
echo "Adding the xtradeb unofficial PPA to install czkawka, chromium, audacity"
echo "---------------------------------------------------------------------------------------------------"

add-apt-repository ppa:xtradeb/apps #Add the xtradeb unofficial PPA

tee -a /etc/apt/preferences.d/xtradeb.pref <<EOF
Package: *
Pin: release o=LP-PPA-xtradeb-*
Pin-Priority: -10

Package: czkawka chromium* audacity*
Pin: release o=LP-PPA-xtradeb-*
Pin-Priority: 999
EOF

echo
echo
echo "---------------------------------------------------------------------------------------------------"
echo "nala / apt install czkawka"
echo "---------------------------------------------------------------------------------------------------"

apt-get update #Update the packages

if ! nala install czkawka; then
    apt install czkawka #Install czkawka from xtradeb PPA
fi


echo "---------------------------------------------------------------------------------------------------"
echo "nala / apt install chromium"
echo "---------------------------------------------------------------------------------------------------"

if ! nala install chromium; then
    apt install chromium #Install chromium from xtradeb PPA
fi

echo "---------------------------------------------------------------------------------------------------"
echo "nala / apt install audacity"
echo "---------------------------------------------------------------------------------------------------"

if ! nala install audacity; then
    apt install audacity #Install audacity from xtradeb PPA
fi

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
