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

#### Resolving errors ####

1. ___Permission denied accessing /run/nordvpn/nordvpnd.sock___

```
Permission denied accessing /run/nordvpn/nordvpnd.sock
```
- ___Resolution___

`sudo usermod -aG nordvpn <non-sudo-user> # Add <non-sudo-users> who are to be allowed to use nordvpn to the nordvpn group`


-----------------------------------------
## Proton VPN

Proton VPN has a free tier which allows only 1 device at a time, and blocks ads. Servers for the free plan are available  only in the USA, Netherlands and Japan

### References

1. [Installation steps](https://protonvpn.com/support/official-linux-vpn-ubuntu)
1. ['OpenSSL_add_all_algorithms' error](https://www.reddit.com/r/ProtonVPN/comments/132cpsv/openssl_add_all_alghoritms_error/?rdt=50650)
1. [Handling errors with pyopenssl cryptography](https://stackoverflow.com/questions/74981558/error-updating-python3-pip-attributeerror-module-lib-has-no-attribute-openss/75053968#75053968) - also referenced in the above


### Steps / Commands

`cd Downloads/`

`wget https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.6_all.deb # From https://protonvpn.com/support/official-linux-vpn-ubuntu`

`sudo dpkg -i ./protonvpn-stable-release_1.0.6_all.deb && sudo apt update`

`sudo apt install proton-vpn-gnome-desktop # From https://protonvpn.com/support/official-linux-vpn-ubuntu`

`protonvpn-app`

#### Resolving errors ####

1.  ___AttributeError: module 'lib' has no attribute 'OpenSSL_add_all_algorithms'___

```
File "/usr/bin/protonvpn", line 11, in <module>
   load_entry_point('protonvpn-gui==1.12.0', 'console_scripts', 'protonvpn')()
 File "/usr/lib/python3/dist-packages/pkg_resources/__init__.py", line 479, in load_entry_point
   return get_distribution(dist).load_entry_point(group, name)
 File "/usr/lib/python3/dist-packages/pkg_resources/__init__.py", line 2861, in load_entry_point
   return ep.load()
 File "/usr/lib/python3/dist-packages/pkg_resources/__init__.py", line 2465, in load
   return self.resolve()
 File "/usr/lib/python3/dist-packages/pkg_resources/__init__.py", line 2471, in resolve
   module = __import__(self.module_name, fromlist=['__name__'], level=0)
 File "/usr/lib/python3/dist-packages/protonvpn_gui/main.py", line 14, in <module>
   from proton.constants import VERSION as proton_version
 File "/usr/lib/python3/dist-packages/proton/__init__.py", line 1, in <module>
   from .api import Session # noqa
 File "/usr/lib/python3/dist-packages/proton/api.py", line 21, in <module>
   from .cert_pinning import TLSPinningAdapter
 File "/usr/lib/python3/dist-packages/proton/cert_pinning.py", line 5, in <module>
   from OpenSSL import crypto
 File "/usr/lib/python3/dist-packages/OpenSSL/__init__.py", line 8, in <module>
   from OpenSSL import crypto, SSL
 File "/usr/lib/python3/dist-packages/OpenSSL/crypto.py", line 3279, in <module>
   _lib.OpenSSL_add_all_algorithms()
AttributeError: module 'lib' has no attribute 'OpenSSL_add_all_algorithms' 
```
- ___Resolution___
 
`sudo pip show cryptography # Check the version`

`sudo pip show pyOpenSSL # Check the version`

`sudo pip install -U pyopenssl cryptography # Upgrade both to the latest version as in https://stackoverflow.com/questions/74981558/error-updating-python3-pip-attributeerror-module-lib-has-no-attribute-openss/75053968#75053968`

`sudo pip show pyOpenSSL # Verify that the version is upgraded`

`sudo pip show cryptography # Verify that the version is upgraded`
