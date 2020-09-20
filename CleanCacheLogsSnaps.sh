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
echo "This script frees up diskspace by cleaning cache, old-logs and disabled snaps if any."
echo "It provides INFORMATION on old kernels that can be deleted manually through other means."
echo "AUTHENTICATION SUCCESSFUL. You are executing the script as" $USER
echo
echo
echo "---------------------------------------------------------------------------------------------------"
echo "Size of all files in /var/log/ folder"
echo "---------------------------------------------------------------------------------------------------"
du -sh /var/log/
#ls -laS /var/log/ | more


echo
echo
echo "---------------------------------------------------------------------------------------------------"
echo "Space taken by *.old files in /var/log/ folder"
echo "------------------------------------------------------------------------"
du -sh /var/log/*.old
ls -laS /var/log/*.old | more
echo "Deleting *.old files in /var/log/ folder"
echo "------------------------------------------------------------------------"
find /var/log -type f -name "*.old" -exec rm -f {} \;


echo
echo
echo "---------------------------------------------------------------------------------------------------"
echo "Space taken by *.gz files in /var/log/ folder"
echo "------------------------------------------------------------------------"
du -sh /var/log/*.gz
ls -laS /var/log/*.gz | more
echo "Deleting *.gz files in /var/log/ folder"
echo "------------------------------------------------------------------------"
find /var/log -type f -name "*.gz" -exec rm -f {} \;

echo
echo
echo "---------------------------------------------------------------------------------------------------"
echo "Space taken by *.1 files in /var/log/ folder"
echo "------------------------------------------------------------------------"
du -sh /var/log/*.1
ls -laS /var/log/*.1 | more
echo "Deleting *.1 files in /var/log/ folder"
echo "------------------------------------------------------------------------"
find /var/log -type f -name "*.1" -exec rm -f {} \;


echo
echo
echo "---------------------------------------------------------------------------------------------------"
echo "Remove disabled snaps"
echo "------------------------------------------------------------------------"
#!/bin/bash
set -eu

snap list --all | awk '/disabled/{print $1, $3}' |
    while read disabledsnapname revision; do
        sudo snap remove "$disabledsnapname" --revision="$revision"
    done

echo
echo
echo "---------------------------------------------------------------------------------------------------"
echo "Space taken by /var/cache/apt folder"
echo "------------------------------------------------------------------------"
du -sh /var/cache/apt/
echo "Cleaning up /var/cache/apt folder. autoclean && autoremove"
echo "------------------------------------------------------------------------"
apt-get autoclean && apt-get autoremove && apt autoclean && apt autoremove

echo
echo
echo "---------------------------------------------------------------------------------------------------"
echo "Space taken by /var/cache/apt/archives"
echo "------------------------------------------------------------------------"
du -sh /var/cache/apt/archives/
echo "Cleaning up /var/cache/apt/archives folder. apt-get clean"
echo "------------------------------------------------------------------------"
# this benefits a lot
apt-get clean


echo
echo
echo "---------------------------------------------------------------------------------------------------"
echo "Space taken by /var/log/journal/* . Also cleaning it up to be less than 10 days and 1 megabyte"
echo "------------------------------------------------------------------------"
du -sh /var/log/journal/*
journalctl --disk-usage
#deletes from /var/log/journal based on timeline specified in value (10 days in this example).
echo "Vacuuming up /var/log/journal/* folder to keep less than 10 days of data"
echo "------------------------------------------------------------------------"
journalctl --vacuum-time=10d
#deletes from /var/log/journal until total size of the directory comes under specified value (500 megabytes in this example).
#journalctl --vacuum-size=500M
echo "------------------------------------------------------------------------"
echo "Vacuuming up /var/log/journal/* folder to keep less than 1 MB days of data"
echo "------------------------------------------------------------------------"
journalctl --vacuum-size=1M
echo
echo
echo "------------------------------------------------------------------------"
echo "Number of Kernel Packages installed"
echo "------------------------------------------------------------------------"
dpkg --list | egrep -i --color 'linux-image|linux-headers' | wc -l
echo
echo
echo "------------------------------------------------------------------------"
echo "List of Kernel Packages installed"
echo "------------------------------------------------------------------------"
dpkg --list | egrep -i --color 'linux-image|linux-headers'
echo
echo
echo "------------------------------------------------------------------------"
echo "Current Kernel is as below. DO NOT REMOVE IT" 
echo "MANUALLY remove others from the above list using SYNAPTIC package manager to address interdependencies"
echo "Check disk space usage before and after removal using 'df -H'" 
echo "------------------------------------------------------------------------"
uname -a
echo
echo
echo "Exit"
