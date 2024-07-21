#!/bin/bash
# Per https://youtu.be/wotkLCoJ_ks
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

echo "Current version of pip is..."
echo "============================"
pip3 --version


echo "Trying to upgrade pip."
echo "======================"

pip3 install --upgrade pip


echo "pip version after trying to upgrade it."
echo "======================================="
pip3 --version

echo "update and upgrade apt"
echo "======================"

apt update && apt upgrade -y

echo "-----------------------------------------"
echo "Install jupyter-notebook with nala or apt"
echo "-----------------------------------------"
if ! nala install jupyter-notebook; then
    apt install jupyter-notebook
fi

echo
echo
echo "Please use the command 'jupyter notebook' at the terminal to use jupyter notebook,"
echo "or add its shortcut to ubuntu dock "
echo "=================================================================================="
