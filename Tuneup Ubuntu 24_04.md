## Tuneup by using shell scripts

Download the following `.sh` files and do `chmod +x` before executing them from the super-user's login

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

Place image here

`sudo cp /usr/lib/x86_64-linux-gnu/sssd/conf/sssd.conf /etc/sssd/. && sudo chmod 600 /etc/sssd/sssd.conf` # *Per https://bugs.launchpad.net/ubuntu/+source/sssd/+bug/2048436*

### Fix errors with mounting ntfs drives

`echo 'blacklist ntfs3' | sudo tee /etc/modprobe.d/disable-ntfs3.conf` # *Per https://bugs.launchpad.net/ubuntu/+source/ntfs-3g/+bug/2062972/comments/18*
