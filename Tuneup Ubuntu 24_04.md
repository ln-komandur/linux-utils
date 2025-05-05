## Tuneup by using shell scripts

Login as super-user. Then download the following `.sh` files. Move them from `~/Downloads` to the sudo users home (`~`) directory. Do `chmod +x *.sh` and then execute them from the super-user's login one by one

### Execute 3 comprehensive shell scripts

`./1_DisableUnnecessaryServices.sh`

`./2_Purge-snapd-install-apt-equivalents.sh`

`./3_Quick-Install.sh`

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

Solution TBD
