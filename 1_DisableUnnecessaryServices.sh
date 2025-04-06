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

echo "Stopping and Disabling NetworkManager-wait-online.service"
systemctl stop NetworkManager-wait-online.service
systemctl disable NetworkManager-wait-online.service

echo "Stopping and Disabling plymouth-quit-wait.service"
systemctl stop plymouth-quit-wait.service
systemctl disable plymouth-quit-wait.service

echo "Stopping and Disabling ModemManager.service"
systemctl stop ModemManager.service
systemctl disable ModemManager.service

echo "Stopping and Disabling ofono.service and dundee.service (IF Installed)"
systemctl stop ofono.service dundee.service
systemctl disable ofono.service dundee.service

