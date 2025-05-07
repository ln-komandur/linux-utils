## Create common mount points for partitions shared by all users and include them in fstab

### This will help 
1. prevent `journalctl -u udisks2` warnings from appearing anytime a super user who mounted these partitions reboots, as the boot process would try to re-mount those partitions using the super user's paths but be unable to do so because the user is not logged in at that time. This warning will look like `udisksd[695]: mountpoint /media/<super-user-name>/<partition-name> is invalid, cannot recover the canonical path`
2. account agnostic directories to mount partitions common to all _user_ and _service_ accounts

## Create directories to map as common mount points for all users using the fstab file
 
`sudo mkdir /media/all-users-<partition-name>` # *Create a directory as a common mount point for all users*

**Note:** Using `sudo` creates directories with the root as their owner and group that can be verified with `ls -l /media/`. This ownership will be changed to a _super user_ in the steps that follow


### Get the UUIDs of partitions at their current mount points 

Use one of the below commands

`sudo blkid | grep UUID=` # *Get the UUID of partitions at their current mount points*

or

`lsblk -o NAME,LABEL,UUID` # *Get the UUID of partitions at their current mount points*

### Edit the fstab file

`sudo nano /etc/fstab` # *Open fstab to add entries for the mount point with /media/\<directories\> against their UUIDs*
 
 ```
# The below lines help to have common paths for these partitions for all users
# Change between auto and noauto based on whether to mount this partition automatically at boot
UUID=99999999-9999-9999-9999-999999999999 /media/all-users-<partition-name> ext4 noauto,nosuid,nodev,noexec,nouser,nofail 0 0
```
fstab takes tabs or spaces in the line entry above. The options at the end of this line mean the following 
* `noauto` - do not mount this partition at boot time. This can be `auto` if the partion is owned by a user who is not a super-user (`<first-user>`) so that it is mounted automatically and without needing to know the super-user's credentials
* `nosuid` - ignore / disregard the setguid (sticky bit) if set
* `nodev` - cannot contain special devices as a security precaution
* `noexec` - binaries cannot be executed in this partition
* `nouser` - only root can mount this partition. In the current context, this setting is intentional to act like a server switch to make the data folder available to nextcloud clients only if root mounts it
* `nofail` - ignore device errors if any

### Verify fstab edits

`sudo mount -a` # *Check if the fstab edits are good and partitions can be mounted at their new mount points*

If necessary execute `sudo systemctl daemon-reload` or `reboot` for fstab edits to take effect

## Add other users to the group of the user who is going to own the mount point (in this case the superuser) to share common files

`sudo gpasswd -a <another-user> <first-user's-group>` # *First-user's-group is the group of those mount points*

`groups <another-user>` # *Verify the `<another-user>` has been added to the `<first-user's-group>`*

**Note:** Use `gpasswd --delete <user> <group>` # *To delete a user from a group if needed*

## Happy Scenario
1.  First mount the volumes that were just configured and check if their path in Nautilus (Ctrl + l) shows their common mount points
2.  Change their group
    1.  If they do not contain any files, then use `sudo chown` and [Change the owner and group from root:root to a different user and group, in this case the super-user](#change-the-owner-and-group-from-rootroot-to-a-different-user-and-group-in-this-case-the-super-user)
    2.  If they **already contain** files, then `sudo chgrp -R <first_user's_group> /media/all-users-<partition-name>` # *Change the group to the <first_user's_group>. Consider additional options -h -H -L for traversing symbolic links*
1.  Lastly use `sudo chmod` to [Set write permission to multiple users using setgid bit](#set-write-permission-to-multiple-users-using-setgid-bit)

## Alternate Scenario - Need to execute a few times

If the happy scenario does not work, execute the `chown`, `chmod`, and `ls` commands a few times with each partition opened in nautilus as `<another-user>` until it is possible to create a new folder in each of them. It is not clear why they do not work in a single attempt or what changes when they are executed repeatedly, and may have to do with fstab changes taking effect (with `systemctl daemon-reload` or `reboot`). While executing them in succession, it is typical to see a `lost+found` folder getting created in them but owned by root. This folder has to eventually be owned by the `<first_user>:<first_user's_group>` by these repeated attempts, and that's when it also seems to become possible to create a new folder in each partition as `<another-user>`

__Important:__ If a file belonging to a group other than `<first-user's-group>` is _moved_ to a common partition owned by the `<first_user>:<first_user's_group>`, then it will not be editable by anyone other than members of the original user's group. Therefore execute the following command after doing such file moves.

`sudo chgrp -R <first_user's_group> /media/all-users-<partition-name>` # *Change the group to the <first_user's_group>. Consider additional options -h -H -L for traversing symbolic links*

The `chmod` command below MAY need to be executed again to cascade down the setgid bit

### Change the owner and group from root:root to a different user and group, in this case the super-user

`sudo chown -R <first_user>:<first_user's_group> /media/all-users-<partition-name>` # *Do not end the directory name with a '/'. Change the owner and group from root:root to a different user and group, in this case the super-user*

**Note:** Add other non-super users to `<first_user's_group>` so that they can access this mount point as a member of the group. If the partition is not auto mounted in fstab or if that group is the super-user's group, then all those other users need to authenticate with the super user's credentials

### Set write permission to multiple users using setgid bit

`sudo chmod -R 2775 /media/all-users-<partition-name>` # *[Refer - set write permission to multiple users](https://ubuntuforums.org/archive/index.php/t-2017287.html). 2 is the setgid [(set group id bit to inherit the group id for users in the group)](https://linuxconfig.org/how-to-use-special-permissions-the-setuid-setgid-bit)*

`ls -l /media/` # Check if the setgid bit, the owner and the group are set correctly


## Allowing non-sudo users to use Veracrypt

## References
[SOLVED: Veracrypt and multiple user accounts](https://forums.linuxmint.com/viewtopic.php?p=1933439) - refer rootbeer's solution

[Creating a veracrypt encrypted volume on Ubuntu](https://linuxconfig.org/full-disk-encryption-with-veracrypt-on-ubuntu-linux)

### Install Veracrypt and encrypt a volume

Use the [Veracrypt PPA from Unit193 on Launchpad](https://launchpad.net/~unit193/+archive/ubuntu/encryption) per the [3rd party binaries referred by Veracrypt](https://veracrypt.fr/en/Contributed%20Resources.html)

Alternatively, [download the veracrypt .deb installable](https://veracrypt.fr/en/Downloads.html) 

Install either of them using `nala` or `apt`.

[Encrypt a desired empty volume](https://linuxconfig.org/full-disk-encryption-with-veracrypt-on-ubuntu-linux), and then mount it as a `sudo` user

### Configure the veracrypt encrypted volume to be mountable by non-sudo users

On the veracrypt encrypted volume, perform the __Steps above to__
1.  __Important:__
    1.  Veracrypt seem to mount volumes as logical volumes. This can be seen by executing `lsblk`.
    1.  Veracrypt mounts encrypted volumes at mount points with a number suffix based on the slot selected to mount the volume (e.g. `/media/veracrypt1`). Even if the same slot is used to mount the encrypted volume everytime, the ownership and the setgid bit at the volume level are not preserved. Files created at the base of the encrpted volume will not take these attributes. 
    1.  __Therefore,__ create a folder named `all-files` at the base of the encrypted volume using `sudo mkdir -p all-files`. It is required to cascade down the ownership and the setgid bit to all files that __MUST BE__ placed only inside this folder. Else the following `chown` and `chmod` will need to be repeatedly executed every time after mounting the veracrypt volume. 
1.  [Change the owner and group from root:root to a different user and group, in this case the super-user](#change-the-owner-and-group-from-rootroot-to-a-different-user-and-group-in-this-case-the-super-user)
1.  [Set write permission to multiple users using setgid bit](#set-write-permission-to-multiple-users-using-setgid-bit)

Then do the following per [rootbeer's solution](https://forums.linuxmint.com/viewtopic.php?p=1913627&sid=7923c6cd8706987055ec0f1c34828d0a#p1913627)

`sudo groupadd veracrypt` # *Create a veracrypt group*

`sudo usermod -aG veracrypt <another-user>`  # *Add `<another-user>` to veracrypt group*

`sudo visudo /etc/sudoers` # *Edit the sudoers-file with visudo to add the veracrypt group*

_add this in the file: below the `%sudo ALL=(ALL:ALL) ALL` line._ It allows users who belong to the `veracrypt` group to execute __ONLY__ `/usr/bin/veracrypt` with `sudo` prilleges __ONLY__ for that executable

`%veracrypt ALL=(ALL) /usr/bin/veracrypt`

It should look like this

```
# Allow members of group sudo to execute any command
%sudo ALL=(ALL:ALL) ALL

%veracrypt ALL=(ALL) /usr/bin/veracrypt
```

Exit `visudo` and save the file using `Ctrl+x`, and reboot the system. 

-  Login as `<another-user>`
-  Open veracrypt GUI app
-  Mount the veracrypt encrypted volume with the password for `<another-user>`, not the password of the `<super-user>`. You may have to try a couple of times with the password of `<super-user>` and `<another-user>`
