### Install firefox from PPA
 
Refer 
 
 https://www.omgubuntu.co.uk/2022/04/how-to-install-firefox-deb-apt-ubuntu-22-04

 https://askubuntu.com/questions/1399383/how-to-install-firefox-as-a-traditional-deb-package-without-snap-in-ubuntu-22
 
 https://bitcoden.com/answers/how-to-install-firefox-as-a-traditional-deb-package-without-snap-in-ubuntu-2204-jammy (solution 4 discusses an interesting aspect)
 
 
`sudo add-apt-repository ppa:mozillateam/ppa`
 
Alter the Firefox package priority to ensure the PPA/deb/apt version of Firefox is preferred. This can be done using a slither of code from FosTips (copy and paste it whole, not line by line):
```
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | sudo tee /etc/apt/preferences.d/mozilla-firefox
```

If you are not removing snapd entirely and only want non-snap firefox, then use the below per https://askubuntu.com/questions/1399383/how-to-install-firefox-as-a-traditional-deb-package-without-snap-in-ubuntu-22 instead of the above
 
```
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001

Package: firefox
Pin: version 1:1snap1-0ubuntu2
Pin-Priority: -1
' | sudo tee /etc/apt/preferences.d/mozilla-firefox
```
 
 
To ensure that unattended upgrades do not reinstall the snap version of Firefox, enter the following command.
 
`echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox`

Finally, remove Firefox from snapd and install Firefox via apt in one go by running this command:

`sudo snap remove firefox && sudo apt install firefox`
