## Create common mount points for partitions shared by all users and include them in fstab

### This will help 
1. prevent `journalctl -u udisks2` warnings from appearing anytime a super user who mounted these partitions reboots, as the boot process would try to re-mount those partitions using the super user's paths but be unable to do so because the user is not logged in at that time. This warning will look like `udisksd[695]: mountpoint /media/<super-user-name>/<partition-name> is invalid, cannot recover the canonical path`
2. account agnostic directories to mount partitions common to all _user_ and _service_ accounts
 
`sudo mkdir /media/all-users-<partition-name>` # *Create a directory as a common mount point for all users*

**Note:** Using `sudo` creates directories with the root user as their owner and group 

`sudo chown -R <non_sudo_user>:<non_sudo_users_group> /media/all-users-<partition-name>` # *Change the owner and group to the user who is NOT a super-user*

**Note:** Add other non -sudo users to <sudo_users_group> so that they can access this mount point as a member of the group, but without needing `sudo` privilleges


### Get the UUIDs of partitions at their current mount points 

Use one of the below commands

`sudo blkid | grep UUID=` # *Get the UUID of partitions at their current mount points*

or

`ls -l /media/` # *Get the UUID of partitions at their current mount points*

### Edit the fstab file

`sudo nano /etc/fstab` # *Open fstab to add entries for the mount point with /media/\<directories\> against their UUIDs*
 
 ```
# The below lines help to have common paths for these partitions for all users
# Change between auto and noauto based on whether to mount this partition automatically at boot
UUID=99999999-9999-9999-9999-999999999999 /media/all-users-<partition-name> ext4 noauto,nosuid,nodev,noexec,nouser,nofail 0 0
```
fstab takes tabs or spaces in the line entry above. The options at the end of this line mean the following 
* `noauto` - do not mount this partition at boot time
* `nosuid` - ignore / disregard the setguid (sticky bit) if set
* `nodev` - cannot contain special devices as a security precaution
* `noexec` - binaries cannot be executed in this partition
* `nouser` - only root can mount this partition. In the current context, this setting is intentional to act like a server switch to make the data folder available to nextcloud clients only if root mounts it
* `nofail` - ignore device errors if any

### Verify edits

`sudo mount -a` # *Check if the fstab edits are good and partitions can be mounted at their new mount points*

## Add another user to group of the first user to share common files

`sudo gpasswd -a another-user firstuser-group` # *Firstuser-group is the group of those mount points*

`sudo chmod -R 2775 /media/\<directories\>` # *[To set write permission to multiple users](https://ubuntuforums.org/archive/index.php/t-2017287.html). 2 is the setgid [(set group id bit to inherit the group id)](https://linuxconfig.org/how-to-use-special-permissions-the-setuid-setgid-and-sticky-bits)*
