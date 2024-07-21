#!/bin/bash

# Instructions from https://signal.org/download/linux/ for using APT package manager to install signal-desktop 
# and keep it up to date on Debian distributions using the package feed. 


echo "================================================="
echo "Getting the gpg key from signal"
echo "================================================="

wget -qO - https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null # Get the key

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

echo "================================================="
echo "Setting up the APT package feed for Signal"
echo "================================================="

sh -c 'echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' | sudo tee /etc/apt/sources.list.d/signal-xenial.list' # Set-up the APT package feed

echo "================================================="
echo "Updating apt"
echo "================================================="


apt update # Update apt

echo "================================================="
echo "Installing Signal-desktop"
echo "================================================="

if ! nala install signal-desktop; then
    apt install signal-desktop # Install signal-desktop
fi
