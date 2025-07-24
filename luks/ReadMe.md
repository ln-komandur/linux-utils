# Creating luks encrypted partition / volume using Gnome Disks utility

## Reference

[Create encrypted partition AFTERWARDS - Linux Mint Tutorial for beginners](https://youtu.be/ThxpcGkZ5d0)

------
## Step 1:
Create an unallocated partition using GParted

![1_Create unallocated partition](./images/1_Create%20unallocated%20partition.png)


------
## Step 2:
Click the **+ icon** and **Create a partition in unallocated space**

![2_0_Create partition in unallocated space](./images/2_0_Create%20partition%20in%20unallocated%20space.png)


------
### Step 2a:
Select the whole size and click **Next**

![2_1_Create partition in unallocated space](./images/2_1_Create%20partition%20in%20unallocated%20space.png)


------
### Step 2b:
1. Enter a **Volume Name** of your choice
2. Select the option ***Internal disk for use with Linux systems only (Ext4)***
3. Check the box ***Password protect volume (LUKS)***
4. Click **Next**

![2_2_Create partition in unallocated space](./images/2_2_Create%20partition%20in%20unallocated%20space.png)


------
### Step 2c:
1. Enter a password and confirm it. This is also called *Pass phrase* in some other screens
2. Click **Create**

***Note:*** This password is not used to encrypt the volume. Instead it is used to decrypt the encryption key stored within the volume's header. This encryption key, in turn, is used to unlock and decrypt the actual data on the storage volume. 

![2_3_Create partition in unallocated space](./images/2_3_Create%20partition%20in%20unallocated%20space.png)


------
### Step 2d:
Notice that the volume will be created in a few seconds (shown as a separate box in the same column)

![2_4_Create partition in unallocated space](./images/2_4_Create%20partition%20in%20unallocated%20space.png)


Congratulations!! Your encrypted volume is now ready for use. However it is not yet configured to automatically mount or decrypt on boot up. You can mount it from nautilus with `sudo` privilleges when it will prompt you to enter the passphrase to decrypt.


# Configure the encrypted volume to automatically mount on boot up

------
## Step 3:
1. Select the top partition
2. Click the **Cog - Additional partition options**

![3_1_Additional partition options](./images/3_1_Additional%20partition%20options.png)


------
### Step 3a:
Select **Edit Encryption Options**

![3_2_Edit Encryption Options](./images/3_2_Edit%20Encryption%20Options.png)


------
### Step 3b:
1. Switch off **User Session Defaults**
2. Make other entries here that will go into the `/etc/crypttab` file

![3_3_Edit Encryption Options](./images/3_3_Edit%20Encryption%20Options.png)


------
### Step 3c:

1. Check **Unlock at system startup**
2. Change **nofail** to **luks** in the box without any label
3. Enter a friendly **Name** for the partition (without the UUID)
4. Do not enter the *passphrase* or select *Show passphrase* here. If you do, it will store it as a plain text key file under `/etc/luks/` and use it to decrypt the volume header on boot up. When you DO NOT enter it here, the system will prompt you for it during boot up. At that time, if you enter it incorrectly thrice, the system will proceed with boot up without decrypting or mounting this volume.
5. Click **OK**

![3_4_Edit Encryption Options](./images/3_4_Edit%20Encryption%20Options.png)


------
## Step 4: 

1. Select the bottom partition
2. Click the **Cog - Additional partition options**

![4_1_Additional partition options](./images/4_1_Additional%20partition%20options.png)


------
### Step 4a:
Select **Edit Mount Options**

![4_2_Edit Mount Options](./images/4_2_Edit%20Mount%20Options.png)


------
### Step 4b:
1. Switch off **User Session Defaults**
2. Make other entries here that will go into the `/etc/fstab` file

![4_3_Mount Options](./images/4_3_Mount%20Options.png)


------
### Step 4c:
1. Check **Mount at system startup**
2. Leave the **Show in User Interface** box checked
3. Edit the **Mount Point** to something friendly. You may want to make this a [common mount point](../../master/common-mountpoints.md) for multiple users

![4_5_Mount Options](./images/4_5_Mount%20Options.png)


------
### Step 4d:
1. Select the **Identify As** to start with the choice **UUID=**
2. Click **OK**

![4_4_Mount Options](./images/4_4_Mount%20Options.png)
