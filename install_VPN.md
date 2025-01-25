# Install VPN

## NordVPN

NordVPN only has paid plans, however with a 30 day free trial. It has servers in several countries and multiple(~10) devices can connect simultaneously even in the most basic plan

### References
[How to install a VPN on Linux](https://nordvpn.com/download/linux/#install-nordvpn)

[Installing NordVPN on Linux distributions](https://support.nordvpn.com/hc/en-us/articles/20196094470929-Installing-NordVPN-on-Linux-distributions)

### Steps / Commands

`sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh) # Install and follow on-screen instructions`

`sudo usermod -aG nordvpn <non-sudo-user-who-is-allowed-to-use-nordvpn> # Add non-sudo-users who are to be allowed to use nordvpn to the nordvpn group`

`getent group nordvpn # Check that the intended users are in the nordvpn group`

`exit # Exit from su`

`nordvpn login # Login to nordvpn. Will be redirected to the browser to enter credentials`

`nordvpn connect # Connect to VPN`

`nordvpn countries # List all countries with nordvpn servers`

`nordvpn connect India # Connect to India server`

`nordvpn disconnect # Disconnect`

#### If getting errors ####

__Permission denied accessing /run/nordvpn/nordvpnd.sock__ - then execute

`sudo usermod -aG nordvpn <non-sudo-user-who-is-allowed-to-use-nordvpn> # Add non-sudo-users who are to be allowed to use nordvpn to the nordvpn group`


-----------------------------------------
## Proton VPN

Proton VPN has a free tier which allows only 1 device at a time, and blocks ads. Servers for the free plan are available  only in the USA, Netherlands and Japan

### References

1. [Installation steps](https://protonvpn.com/support/official-linux-vpn-ubuntu)
1. [Handling errors with pyopenssl cryptography](https://stackoverflow.com/questions/74981558/error-updating-python3-pip-attributeerror-module-lib-has-no-attribute-openss/75053968#75053968)


### Steps / Commands

`cd Downloads/`

`wget https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.6_all.deb # From https://protonvpn.com/support/official-linux-vpn-ubuntu`

`sudo dpkg -i ./protonvpn-stable-release_1.0.6_all.deb && sudo apt update`

`sudo apt install proton-vpn-gnome-desktop # From https://protonvpn.com/support/official-linux-vpn-ubuntu`

`protonvpn-app`

#### If getting errors ####
 
`sudo pip show cryptography`

`sudo pip show pyOpenSSL`

`sudo pip install -U pyopenssl cryptography # From https://stackoverflow.com/questions/74981558/error-updating-python3-pip-attributeerror-module-lib-has-no-attribute-openss/75053968#75053968`

`sudo pip show pyOpenSSL`

`sudo pip show cryptography`
