# Use Veracrypt to encrypt volumes

## References
[Creating a veracrypt encrypted volume on Ubuntu](https://linuxconfig.org/full-disk-encryption-with-veracrypt-on-ubuntu-linux)

[SOLVED: Veracrypt and multiple user accounts](https://forums.linuxmint.com/viewtopic.php?p=1933439) - refer rootbeer's solution

## Veracrypt Installation

Use the [Veracrypt PPA from Unit193 on Launchpad](https://launchpad.net/~unit193/+archive/ubuntu/encryption) per the [3rd party binaries referred by Veracrypt](https://veracrypt.fr/en/Contributed%20Resources.html)

Alternatively, [download the veracrypt .deb installable](https://veracrypt.fr/en/Downloads.html) 

Install either of them using `nala` or `apt`.

[Encrypt a desired empty volume](https://linuxconfig.org/full-disk-encryption-with-veracrypt-on-ubuntu-linux), and then mount it as a `sudo` user

## Create [common mount points](../common-mountpoints.md) to mount Veracrypt encrypted volumes

**Background:**
1.  By executing `lsblk`, it can be observed that Veracrypt seem to mount encrypted volumes as logical volumes at mount points with a number suffix based on the slot selected to mount the volume (e.g. `/media/veracrypt1`).
1.  Even if the same slot is used to mount the encrypted volume everytime, the ownership and the setgid bit at the volume level are not preserved. Files created at the base of the encrpted volume will not take these attributes. **Therefore,** create a folder named `all-files` at the base of the encrypted volume using `sudo mkdir -p /media/veracrypt1/all-files`. It is required to cascade down the ownership and the setgid bit to all files that __MUST BE__ placed only inside this folder. Else the following `chown` and `chmod` will need to be repeatedly executed every time after mounting the veracrypt volume. 

**On the veracrypt encrypted volume**, perform the following
1.  `sudo chown -R <super_user>:<super_user's_group> /media/veracrypt1/` # *[Change the owner and group from root:root to a different user and group, in this case the super-user](../common-mountpoints.md#change-the-owner-and-group-from-rootroot-to-a-different-user-and-group-in-this-case-the-super-user)*
1.  `sudo chmod -R 2775 /media/veracrypt1/` # *[Set write permission to multiple users using setgid bit](../common-mountpoints.md#set-write-permission-to-multiple-users-using-setgid-bit)*

## Allow non-sudo users to execute Veracrypt GUI application

Perform the below [modified solution to keep configurations in a separate sudoers file](https://sourceforge.net/p/veracrypt/discussion/general/thread/b738c75977/?page=2#bf01/1151/dfbd) based on [rootbeer's solution](https://forums.linuxmint.com/viewtopic.php?p=1913627&sid=7923c6cd8706987055ec0f1c34828d0a#p1913627)

`sudo groupadd veracrypt` # *Create a veracrypt user-group*

`sudo usermod -aG veracrypt <another-user>`  # *Add `<another-user>` to veracrypt user-group*

`echo -e "# Allow members of group user-veracrypt to execute veracrypt \n%veracrypt ALL=(ALL) /usr/bin/veracrypt" | sudo tee "/etc/sudoers.d/veracrypt-users"` # *Add the veracrypt user-group to a separate sudoers file and allow them to execute veracrypt*

-  Login as `<another-user>`
-  Open Veracrypt GUI application
-  Mount the veracrypt encrypted volume with the password for `<another-user>`, not the password of the `<super-user>`. You may have to try a couple of times with the password of `<super-user>` and `<another-user>`
