## Install firefox from PPA
 
References: 
1.   [How to Install Firefox as a .Deb on Ubuntu 22.04 (Not a Snap)](https://www.omgubuntu.co.uk/2022/04/how-to-install-firefox-deb-apt-ubuntu-22-04)
2.   [How to install Firefox as a traditional deb package (without snap) in Ubuntu 22.04 or later versions?](https://askubuntu.com/questions/1399383/how-to-install-firefox-as-a-traditional-deb-package-without-snap-in-ubuntu-22)

### Add mozillateam ppa
 
`sudo add-apt-repository ppa:mozillateam/ppa` #Add the mozillateam ppa

### Alter the Firefox package priority to ensure the PPA/deb/apt version is preferred
#### DO NOT SKIP this step EVEN if you are [removing snap](why-not-snapd.md) entirely

This can be done using a [slither of code from FosTips quoted in omgubuntu](https://www.omgubuntu.co.uk/2022/04/how-to-install-firefox-deb-apt-ubuntu-22-04) **while logged in as a su** (copy and paste it whole, not line by line):
```
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | sudo tee /etc/apt/preferences.d/mozilla-firefox
```
#Priority for PPA/deb/apt version for firefox

### Ensure that unattended upgrades do not reinstall the snap version of Firefox
#### Skip this step if you are [removing snap](why-not-snapd.md) entirely
 
`echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox` #Prevent unattended upgrades from reinstalling snap version of Firefox

### Remove Firefox from snapd and install via apt in one go

`sudo snap remove firefox && sudo apt install firefox` #Remove snap firefox and install apt firefox
