## Tuneup by using shell scripts

Login as super-user. Then download the following `.sh` files. Move them from `~/Downloads` to the sudo users home (`~`) directory. Do `chmod +x *.sh` and then execute them from the super-user's login one by one

### Execute 3 comprehensive one-time-use shell scripts

`./1_DisableUnnecessaryServices.sh`

`./2_Purge-snapd-install-apt-equivalents.sh`

`./3_Quick-Install.sh #` *Watch for **mdraid** warnings and answer Y or N at the prompt*`

### Install zoom and signal through shell scripts

`./zoom-updater.sh`

`./install_signal-desktop.sh`

### Clean up installations

`./DiskSpaceJanitor.sh`


## Fix key errors

### "Dependencies failed" for SSSD

![Alt text](sssd%20dependency%20failed.jpg "sssd dependency failed")

`sudo cp /usr/lib/x86_64-linux-gnu/sssd/conf/sssd.conf /etc/sssd/. && sudo chmod 600 /etc/sssd/sssd.conf` # *Per https://bugs.launchpad.net/ubuntu/+source/sssd/+bug/2048436*

### Fix errors with mounting ntfs drives

`echo 'blacklist ntfs3' | sudo tee /etc/modprobe.d/disable-ntfs3.conf` # *Per https://bugs.launchpad.net/ubuntu/+source/ntfs-3g/+bug/2062972/comments/18*

### spi-nor errors on boot

![Alt text](spi-nor%20failed.jpg "spi-nor failed")

**spi-nor spi0.0: probe with driver spi-nor failed with error -22**

`echo 'blacklist spi_intel_platform' | sudo tee /etc/modprobe.d/06-spi-intel.conf` # *Per https://github.com/fwupd/fwupd/issues/5643#issuecomment-2727295026*

### Map Super+e to open Nautilus at /home

`gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']"` # *Map Super+e to open Nautilus at /home. This can be done in Settings GUI too*


### Correct enlarged display in Dell Inspiron 3542 / Inspiron 5559

**Note** :  Display resolution on Dell Inspiron 3542 / Inspiron 5559 is *1366x768 (16:9)* causing enlarged icons and texts. The below changes will have to be done for **each user separately**

`gsettings set org.gnome.shell.extensions.ding icon-size small` # *Reduce the Desktop icon size from standard to small. This can be done in Settings GUI too*

`gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 40` # *Reduce the dock icon size to 40 from the default 48. This can be done in Settings GUI too*

`gsettings set org.gnome.desktop.interface text-scaling-factor 0.85` # *Reduce the text scaling factor from 1.00 to 0.85. This needs gnome-tweaks to change via GUI*

