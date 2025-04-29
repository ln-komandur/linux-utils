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

`groups <another-user>` # Verify the `<another-user>` has been added to the `<first-user's-group>`

**Note:** Use `gpasswd --delete <user> <group>` # To delete a user from a group if needed

## Need to execute a few times

The following 3 commands (`chown`, `chmod`, and `ls`) need to be executed a few times with each partition opened in nautilus as `<another-user>` until it is possible to create a new folder in each of them. It is not clear why they do not work in a single attempt or what changes when they are executed repeatedly, and may have to do with fstab changes taking effect (with `systemctl daemon-reload` or `reboot`). While executing them in succession, it is typical to see a `lost+found` folder getting created in them but owned by root. This folder has to eventually be owned by the `<first_user>:<first_user's_group>` by these repeated attempts, and that's when it also seems to become possible to create a new folder in each partition as `<another-user>`

### Change the owner and group from root:root to a different user and group, in this case the super-user

`sudo chown -R <first_user>:<first_user's_group> /media/all-users-<partition-name>` # *Do not end the directory name with a '/'. Change the owner and group from root:root to a different user and group, in this case the super-user*

**Note:** Add other non-super users to `<first_user's_group>` so that they can access this mount point as a member of the group. If the partition is not auto mounted in fstab or if that group is the super-user's group, then all those other users need to authenticate with the super user's credentials

### Set write permission to multiple users using setgid and sticky bits

`sudo chmod -R 2775 /media/all-users-<partition-name>` # *[Refer - set write permission to multiple users](https://ubuntuforums.org/archive/index.php/t-2017287.html). 2 is the setgid [(set group id bit to inherit the group id for users in the group)](https://linuxconfig.org/how-to-use-special-permissions-the-setuid-setgid-and-sticky-bits)*

`ls -l /media/` # Check if the sticky bit, the owner and the group are set correctly


## Configure a veracrypt volume to be mountable by non-sudo users

## Reference
[SOLVED: Veracrypt and multiple user accounts](https://forums.linuxmint.com/viewtopic.php?p=1933439) - refer rootbeer's solution

[Download the veracrypt .deb installable](https://veracrypt.fr/en/Downloads.html) and install it using `nala` or `apt`. Encrypt a desired empty volume, and then mount it as a `sudo` user

Then, on that volume, perform the __Steps above to__
1.   __Change the owner and group from root:root to a different user and group, in this case the super-user__
2.   __Set write permission to multiple users using setgid and sticky bits__

Then do the following per [rootbeer's solution](https://forums.linuxmint.com/viewtopic.php?p=1913627&sid=7923c6cd8706987055ec0f1c34828d0a#p1913627)

`sudo groupadd veracrypt` #Create a veracrypt group

`sudo usermod -aG veracrypt <another-user>`  #Add <another-user> to veracrypt group

`sudo visudo /etc/sudoers` #Edit the sudoers-file with visudo to add the veracrypt group

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
