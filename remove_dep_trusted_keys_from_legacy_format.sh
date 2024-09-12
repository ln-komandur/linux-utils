#!/bin/bash

# Instructions for removing deprecated trusted keys stored in legacy trusted.gpg keyring (/etc/apt/trusted.gpg) after converting them to the new format using individual .gpg files located in /etc/apt/trusted.gpg.d
# Source reference https://askubuntu.com/questions/1407632/key-is-stored-in-legacy-trusted-gpg-keyring-etc-apt-trusted-gpg

### 

echo "========================================================================="
echo "convert_legacy_trusted_keys_to_new_format.sh converts all deprecated trusted keys stored in legacy trusted.gpg keyring to the new format"

while true; do
    echo "========================================================================="
    read -p "Have you converted them? (Y/N)" yn
    case $yn in
        [Yy]* ) echo "REMOVING deprecated trusted keys stored in legacy trusted.gpg keyring (/etc/apt/trusted.gpg)"; 
                break;;
        [Nn]* ) echo "FIRST please use convert_legacy_trusted_keys_to_new_format.sh to convert all deprecated trusted keys stored in legacy trusted.gpg keyring to the new format";
                echo "EXITING"
                exit 1;
                break;;
        * ) echo "Please answer Y or N.";;
    esac
done



# One liner below - commented
# for KEY in $(apt-key --keyring /etc/apt/trusted.gpg list | grep -E "(([ ]{1,2}(([0-9A-F]{4}))){10})" | tr -d " " | grep -E "([0-9A-F]){8}\b" ); do K=${KEY:(-8)}; sudo apt-key --keyring /etc/apt/trusted.gpg del $K; done

# More readable
for KEY in $( \ #Cycle through each key suffix, placing the current suffix in the KEY variable
    apt-key --keyring /etc/apt/trusted.gpg list \ #Retrieve the list of known keys:
    | grep -E "(([ ]{1,2}(([0-9A-F]{4}))){10})" \ #Find all groupings of hexadecimal characters that have 1 or 2 spaces in front of them, and are 4 characters long. Get the collection of those that have 10 groupings per line. This provides the full key signature.
    | tr -d " " \ #Trim away (delete) all spaces on each line found, so that key signature is unbroken by white space
    | grep -E "([0-9A-F]){8}\b" \ #Grab the last 8 characters of each line
); do
    K=${KEY:(-8)} #Assign the last 8 characters to the variable K
    sudo apt-key --keyring /etc/apt/trusted.gpg del $K #Remove deprecated keys from /etc/apt/trusted.gpg
done #Loop until all keys are processed
