Reference [How to Install Flatpak & Flathub on Ubuntu (Complete Guide)](https://www.omgubuntu.co.uk/how-to-install-flatpak-on-ubuntu)

**Warning:** Much like snap, being in a sandbox, Flatpak apps also occupy more disk space than if they had been installed using apt or .deb . However, the default location where apps are installed can be changed from `/var/lib/flatpak`

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

Install flatpak apps using 
1.  the **Software app** GUI - Installs them in the root partition under `/var/lib/flatpak`
2.  Save space on /root if /home is on a different partition. [Reference](https://www.reddit.com/r/flatpak/comments/a1l8wk/methods_to_save_space_on_your_root_partition/)
    1.  `flatpak --user install flathub <org.application.name>` #installs apps in /home instead of /root & saves space on /root 
    2.  `sudo mv /var/lib/flatpak /home/user && cd /var/lib && sudo ln -s /home/user/flatpak flatpak` #moves flatpak apps from /root to /home and creates a the symbolic link at /var/lib for all flatpak apps to get routed and installed in /home
