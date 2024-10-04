# Manage keyring files

## Useful references

1.    [Ubuntu’s Repository System](https://itsfoss.com/ubuntu-repository-mechanism/)
2.    [Handling "apt-key is deprecated"](https://itsfoss.com/apt-key-deprecated/) - explains 2 anamolies
      1.   Keyrings and keeping GPG keys in separate files
      2.   Cross referencing keys and how to prevent them
3.    [Installing Packages From External Repositories](https://itsfoss.com/adding-external-repositories-ubuntu/)
4.    [Using apt Commands in Linux - Ultimate Guide](https://itsfoss.com/apt-command-guide)
5.    [The Ultimate Guide to PPA in Ubuntu](https://itsfoss.com/ppa-guide/)
  

## Examples
### 1. GPG file is not mapped to the source. i.e. cross referencing is not addressed
```
:~$ cat /etc/apt/sources.list.d/ubuntuhandbook1-ubuntu-audacity-jammy.list 
deb https://ppa.launchpadcontent.net/ubuntuhandbook1/audacity/ubuntu/ jammy main

```
### 2. GPG file is mapped to the source. i.e. cross referencing is addressed / avoided
```
:~$ cat /etc/apt/sources.list.d/signal-xenial.list 
deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main

```

https://askubuntu.com/questions/1407632/key-is-stored-in-legacy-trusted-gpg-keyring-etc-apt-trusted-gpg - gives one line commands to 
1. [convert_legacy_trusted_keys_to_new_format.sh](convert_legacy_trusted_keys_to_new_format.sh)
2. [remove_dep_trusted_keys_from_legacy_format.sh](remove_dep_trusted_keys_from_legacy_format.sh) after they have been converted 

From a [comment on itsfoss](https://itsfoss.com/apt-key-deprecated/?ht-comment-id=12344336), we learn that the [Debian man page](https://manpages.debian.org/bookworm/apt/sources.list.5.en.html) - states "The recommended locations for keyrings are `/usr/share/keyrings` for keyrings managed by packages, and `/etc/apt/keyrings` for keyrings managed by the system operator." 
1. [This means](https://forums.whonix.org/t/apt-repository-signing-keys-per-apt-sources-list-signed-by/12302) when using the `signed-by=` clause, APT signing keys (`.gpg` files) should be stored in the  `/usr/share/keyrings/` folder instead of `/etc/apt/trusted.gpg.d` .
2. Also, when manually editing the `.list` file under `/etc/apt/sources.list.d/` use the `sudo add-apt-repository` command to add a PPA such as `sudo add-apt-repository ppa:nextcloud-devs/client` instead of adding a source via GUI. This will ensure that the edited entry with the `signed-by` clause in the `.list` file under `/etc/apt/sources.list.d/` is kept / retained and a duplicate entry is not added when using the GUI to add a source.


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
deb [arch=amd64 signed-by=/usr/share/keyrings/<signing-key-file>.gpg] http://mirror.mariadb.org/repo/10.11/ubuntu/ jammy main
```

Or by removing multi-architecture support only if there are no 32 bit applications using the command as below

`dpkg --get-selections | grep 386 #Show packages using 32 bit`

`sudo dpkg --remove-architecture i386 #Remove multi architecture - only if you have no 32 bit applications`
