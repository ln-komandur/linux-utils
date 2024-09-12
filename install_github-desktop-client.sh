#!/bin/bash

# Instructions for using APT package manager to install github-desktop and keep it up to date on Debian distributions.
# from https://apt.packages.shiftkey.dev/ 
# also from https://github.com/shiftkey/desktop under @shiftkey package feed. 

echo
echo "======================================================================================"
echo "Installing the gpg public software signing key for the APT feed from @shiftkey or @mwt"
echo "======================================================================================"
echo

# Use only one of the 2 APT package feed options below
# wget -qO - https://apt.packages.shiftkey.dev/gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/shiftkey-packages.gpg > /dev/null # Get the key from @shiftkey APT package feed 
wget -qO - https://mirror.mwt.me/shiftkey-desktop/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/mwt-desktop.gpg > /dev/null # Get the key from @mwt APT package feed


# Check if the user is su
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

echo
echo "================================================="
echo "Adding APT package feed for shiftkey to list of repositories"
echo "================================================="
echo

# Use only one of the 2 APT package feed options below
# sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/shiftkey-packages.gpg] https://apt.packages.shiftkey.dev/ubuntu/ any main" > /etc/apt/sources.list.d/shiftkey-packages.list' # Set-up the @shiftkey APT package feed 
sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/mwt-desktop.gpg] https://mirror.mwt.me/shiftkey-desktop/deb/ any main" > /etc/apt/sources.list.d/mwt-desktop.list' # Set-up the @mwt APT package feed

echo
echo "================================================="
echo "Updating the apt package database"
echo "================================================="
echo

apt update # Update apt

echo
echo "================================================="
echo "Installing github-desktop"
echo "================================================="
echo

if ! nala install github-desktop; then
    apt install github-desktop # Install github-desktop
fi
