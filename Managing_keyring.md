# Manage keyring files

https://itsfoss.com/apt-key-deprecated/ - explains 2 anamolies around apt-key deprecation 
 1. Keyrings and keeping GPG keys in separate files
 2. Cross referencing keys and how to prevent them

https://askubuntu.com/questions/1407632/key-is-stored-in-legacy-trusted-gpg-keyring-etc-apt-trusted-gpg - gives one line commands to 
1. convert legacy trusted keys - saved in [convert_legacy_trusted_keys_to_new_format.sh](convert_legacy_trusted_keys_to_new_format.sh)
2. remove deprecated trusted keys that have been converted already -  - saved in [remove_dep_trusted_keys_from_legacy_format.sh](remove_dep_trusted_keys_from_legacy_format.sh)

[Debian man page](https://manpages.debian.org/bookworm/apt/sources.list.5.en.html) - states "The recommended locations for keyrings are `/usr/share/keyrings` for keyrings managed by packages, and `/etc/apt/keyrings` for keyrings managed by the system operator."
