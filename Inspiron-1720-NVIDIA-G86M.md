## Only for Dell Inspiron 1720 with NVIDIA G86M [GeForce 840M GS] Graphics card
### Driver Installation error
Install NVIDIA binary driver - vesion 340.108 from nvidia-340 (properitary, tested) from "Additional Drivers" in the GUI. If you get an error as below
``` 
 pk-client-error-quark: The following packages have unmet dependencies:
  nvidia-340: Depends: lib32gcc-s1 but it is not going to be installed
              Depends: libc6-i386 but it is not going to be installed (268)
```
then re-attempt the installation like below from the terminal

`sudo ubuntu-drivers autoinstall`

This will give the same errors as in the GUI, but with the version of the package it is expecting. In this case 2.31-0ubuntu9.2 (For e.g. downgrade from 2.31-0ubuntu9.3). Install those specific version of the package like below.

`sudo apt-get install libc6=2.31-0ubuntu9.2 libc-bin=2.31-0ubuntu9.2`

`sudo apt-get install libc6-i386`
 
And then re-attempt the driver installation

`sudo ubuntu-drivers autoinstall`

`sudo apt-get update`

Reference https://askubuntu.com/questions/1315906/unmet-dependencies-libc6-the-package-system-is-broken

 
### NVRM VGA errors in dmesg
Execute `dmesg | grep NVRM` and see if you get the errors below

```
[   17.214717] NVRM: Your system is not currently configured to drive a VGA console
[   17.214720] NVRM: on the primary VGA device. The NVIDIA Linux graphics driver
[   17.214723] NVRM: requires the use of a text-mode VGA console. Use of other console
[   17.214726] NVRM: drivers including, but not limited to, vesafb, may result in
[   17.214729] NVRM: corruption and stability problems, and is not supported.
```
Then edit the `/etc/default/grub` file and add kernel parameters to the line

`GRUB_CMDLINE_LINUX="video=vesa:off vga=normal"` and execute
 
`sudo update-grub`
 
### Disable NVIDIA Splash screen
 
Execute `sudo nvidia-xconfig --no-logo` to disable NVIDIA Splash screen and `sudo nvidia-xconfig --logo` to enable it back again if needed
