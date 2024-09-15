# Manage keyring files

https://itsfoss.com/apt-key-deprecated/ - explains 2 anamolies around apt-key deprecation 
 1. Keyrings and keeping GPG keys in separate files
 2. Cross referencing keys and how to prevent them

## Examples
### 1. GPG file is not mapped to the source. i.e. cross referencing is not address
```
:~$ cat /etc/apt/sources.list.d/ubuntuhandbook1-ubuntu-audacity-jammy.list 
deb https://ppa.launchpadcontent.net/ubuntuhandbook1/audacity/ubuntu/ jammy main

```
### 2. GPG file is mapped to the source. i.e. cross referencing is address
```
:~$ cat /etc/apt/sources.list.d/signal-xenial.list 
deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main

```

https://askubuntu.com/questions/1407632/key-is-stored-in-legacy-trusted-gpg-keyring-etc-apt-trusted-gpg - gives one line commands to 
1. [convert_legacy_trusted_keys_to_new_format.sh](convert_legacy_trusted_keys_to_new_format.sh)
2. [remove_dep_trusted_keys_from_legacy_format.sh](remove_dep_trusted_keys_from_legacy_format.sh) after they have been converted 

[Debian man page](https://manpages.debian.org/bookworm/apt/sources.list.5.en.html) - states "The recommended locations for keyrings are `/usr/share/keyrings` for keyrings managed by packages, and `/etc/apt/keyrings` for keyrings managed by the system operator."


## Handling Errors
### Repo doesn't support i386 arch

[Reference](https://askubuntu.com/questions/741410/skipping-acquire-of-configured-file-main-binary-i386-packages-as-repository-x)

```
:~$ sudo apt update
>
>
N: Skipping acquire of configured file 'main/binary-i386/Packages' as repository 'http://mirror.mariadb.org/repo/10.11/ubuntu jammy InRelease' doesn't support architecture 'i386'
```
This error is caused because the source list entry does not specify the architecture
```
:~$ cat /etc/apt/sources.list.d/mirror_mariadb_org_repo_10_11_2_ubuntu_-jammy.list
deb http://mirror.mariadb.org/repo/10.11/ubuntu/ jammy main
```
The solution is to add the architecture flag inside the square brackets, separated from the other arguments with a space `[arch=amd64] `. Here is an example :
```
:~$ cat /etc/apt/sources.list.d/mirror_mariadb_org_repo_10_11_2_ubuntu_-jammy.list
deb [arch=amd64] http://mirror.mariadb.org/repo/10.11/ubuntu/ jammy main
```

Or

```
:~$ cat /etc/apt/sources.list.d/mirror_mariadb_org_repo_10_11_2_ubuntu_-jammy.list
deb [arch=amd64 signed-by=/..................../] http://mirror.mariadb.org/repo/10.11/ubuntu/ jammy main
```

Or by removing multi-architecture support only if there are no 32 bit applications using the command as below

`sudo dpkg --remove-architecture i386`
