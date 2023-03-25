Reference [How to Install Flatpak & Flathub on Ubuntu (Complete Guide)](https://www.omgubuntu.co.uk/how-to-install-flatpak-on-ubuntu)

**Warning:** Much like snap, being in a sandbox, Flatpak apps also occupy more disk space than if they had been installed using apt or .deb . However, the default location where apps are installed can be changed from `/var/lib/flatpak`

# Default install
1.  `sudo apt install flatpak gnome-software-plugin-flatpak gnome-software`
2.  `flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo`
3.  `reboot`

Query and check the installation

4.  `echo $XDG_DATA_DIRS`
5.  `flatpak list` 
6.  `flatpak --version`
7.  `flatpak search postman`
8.  `flatpak search telegram`
9.  `flatpak search libreoffice`

## Install flatpak apps for default method above
Use one of the below 
1.  the **Software app** GUI - Installs them in the root partition under `/var/lib/flatpak`
2.  Save space on /root if /home is on a different partition. [Reference](https://www.reddit.com/r/flatpak/comments/a1l8wk/methods_to_save_space_on_your_root_partition/)
    1.  `flatpak --user install flathub <org.application.name>` #installs apps in /home instead of /root & saves space on /root 
    2.  `sudo mv /var/lib/flatpak /home/user && cd /var/lib && sudo ln -s /home/user/flatpak flatpak` #moves flatpak apps from /root to /home and creates a the symbolic link at /var/lib for all flatpak apps to get routed and installed in /home


# Install & maintain flatpak on a separate (dedicated) partition
This saves space on /root [Reference - Tips and Tricks - adding a custom installation](https://docs.flatpak.org/en/latest/tips-and-tricks.html#adding-a-custom-installation)
1.   [Create a separate (dedicated) flatpak partition](./common-mountpoints.md) with a common mount point
2.   `sudo mkdir /etc/flatpak`
3.   `sudo mkdir /etc/flatpak/installations.d`
4.   `sudo gedit /etc/flatpak/installations.d/extra.conf` and paste the below block
```
[Installation "My-flatpak-apps"]
Path=<path to flatpak mount point>
DisplayName=My-flatpak-apps
StorageType=harddisk
```

## Install / Uninstall flatpak apps on the **separate (dedicated) partition**
1.   `flatpak --installation=My-flatpak-apps remote-add flathub https://flathub.org/repo/flathub.flatpakrepo` #Add the flathub remote to the install location
2.   `flatpak --installation=My-flatpak-apps install flathub <org.application.name>` #Install <org.application.name> at My-flatpak-apps
3.   `flatpak --installation=My-flatpak-apps list` #Lists apps from My-flatpak-apps installation location
4.   `flatpak --installation=My-flatpak-apps uninstall flathub <org.application.name>` #Uninstall <org.application.name> at My-flatpak-apps
5.   `flatpak --installation=My-flatpak-apps list` -#Lists apps from My-flatpak-apps install location


# List and Run flatpak apps
Applies for both methods
1.   `flatpak list` #Lists all flatpak applications
2.   `flatpak run flathub <org.application.name>` #Runs the <org.application.name> app
