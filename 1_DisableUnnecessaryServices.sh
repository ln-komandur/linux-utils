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

# This script disables unnecessary services to speed up boot process. 
echo "AUTHENTICATION SUCCESSFUL. You are executing the script as" $USER
echo
echo
echo "---------------------------------------------------------------------------------------------------"
echo "Stopping many unnecessary services if installed"
echo "(1) NetworkManager-wait-online.service"
echo "(2) plymouth-quit-wait.service"
echo "(3) ModemManager.service"
echo "(4) ofono.service dundee.service"
echo "(5) dundee.service"
echo "(6) blueman-mechanism.service"
echo "---------------------------------------------------------------------------------------------------"
systemctl stop NetworkManager-wait-online.service plymouth-quit-wait.service ModemManager.service ofono.service dundee.service blueman-mechanism.service

echo
echo
echo "---------------------------------------------------------------------------------------------------"
echo "Disabling many unnecessary services if installed"
echo "(1) NetworkManager-wait-online.service"
echo "(2) plymouth-quit-wait.service"
echo "(3) ModemManager.service"
echo "(4) ofono.service dundee.service"
echo "(5) dundee.service"
echo "(6) blueman-mechanism.service"
echo "---------------------------------------------------------------------------------------------------"
systemctl disable NetworkManager-wait-online.service plymouth-quit-wait.service ModemManager.service ofono.service dundee.service blueman-mechanism.service

echo
echo
echo "---------------------------------------------------------------------------------------------------"
echo "Purging"
echo "(1) plymouth"
echo "(2) bluedevil" 
echo "(3) modemmanager"
echo "apt-get purge plymouth bluedevil modemmanager"
echo "---------------------------------------------------------------------------------------------------"
apt-get purge plymouth bluedevil modemmanager
