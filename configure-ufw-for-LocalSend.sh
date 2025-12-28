#!/bin/bash
#ref: https://unix.stackexchange.com/questions/28791/prompt-for-sudo-password-and-programmatically-elevate-privilege-in-bash-script
#ref: https://askubuntu.com/a/30157/8698
#
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

echo "This script configures Uncomplicated Firewall (UFW) for LocalSend app installation by opening port 53319 for incoming and outgoing traffic on TCP and UDP"
echo "#########################################################################################################################################################"
echo
echo "AUTHENTICATION SUCCESSFUL. You are executing the script as" $USER
echo
#http://moo.nac.uci.edu/~hjm/biolinux/Linux_Tutorial_12.html - gives "ifconfig | grep -A1 "wlan\|wlp"| grep inet | cut -f2 -d: | cut -f1 -d' ' "
#https://www.unix.com/shell-programming-and-scripting/112831-trim-last-octate-ip-address-using-bash-script.html - trim last octate of ip address using bash script

wlan_ip4address_3_blocks=`ip a | grep -A1 "wlan\|wlp"| grep inet | cut -f6 -d' ' | cut -f1 -d/ | cut -f1-3 -d.`
#echo "The first 3 blocks of wireless IP4 address of this server is : " $wlan_ip4address_3_blocks

subnet_mask_CIDR_format=$wlan_ip4address_3_blocks".0/24"

router_address=$wlan_ip4address_3_blocks".1"

echo "Subnet mask CIDR format "$subnet_mask_CIDR_format
echo
echo "Router address "$router_address
echo
echo "UFW Status is : "
ufw status
echo

echo "Adding a rule to open and allow all incoming TCP and UDP packets on port 53317"
ufw allow from $subnet_mask_CIDR_format to any port 53317 comment \"Incoming\ TCP\ and\ UDP\ on\ 53317\ for\ LocalSend-App\" #opens and allows incoming TCP packets on port 53317
echo

echo "Adding a rule to open and allow all outgoing TCP and UDP packets on port 53317"
ufw allow out to $subnet_mask_CIDR_format port 53317 comment \"Outgoing\ TCP\ and\ UDP\ on\ 53317\ for\ LocalSend-App\" #opens and allows outgoing TCP packets on port 53317
echo

echo "Refreshing UFW "
ufw disable && ufw enable && ufw status # Refresh UFW 

echo
echo "Exiting"
exit
