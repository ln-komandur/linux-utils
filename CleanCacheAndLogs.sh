echo "You are executing the Cache and Log clean-up script as" $USER
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
echo "Space taken by /var/cache/apt folder"
echo "------------------------------------------------------------------------"
du -sh /var/cache/apt/
echo "Cleaning up /var/cache/apt folder"
echo "------------------------------------------------------------------------"
apt-get autoclean && apt-get autoremove && apt autoclean && apt autoremove

echo
echo
echo "---------------------------------------------------------------------------------------------------"
echo "Space taken by /var/cache/apt/archives"
echo "------------------------------------------------------------------------"
du -sh /var/cache/apt/archives/
echo "Cleaning up /var/cache/apt/archives folder"
echo "------------------------------------------------------------------------"
# this benefits a lot
apt-get clean


echo
echo
echo "---------------------------------------------------------------------------------------------------"
echo "Cleaning up other stuff - apt-get autoclean && apt-get autoremove && apt autoclean && apt autoremove"
echo "------------------------------------------------------------------------"
apt-get autoclean && apt-get autoremove && apt autoclean && apt autoremove


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

