#!/bin/bash

# Instructions for converting  all deprecated keys stored in legacy trusted.gpg keyring (/etc/apt/trusted.gpg) to the new format using individual .gpg files located in /etc/apt/trusted.gpg.d
# Source reference https://askubuntu.com/questions/1407632/key-is-stored-in-legacy-trusted-gpg-keyring-etc-apt-trusted-gpg

# One liner below - commented
# for KEY in $(apt-key --keyring /etc/apt/trusted.gpg list | grep -E "(([ ]{1,2}(([0-9A-F]{4}))){10})" | tr -d " " | grep -E "([0-9A-F]){8}\b" ); do K=${KEY:(-8)}; apt-key export $K | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/imported-from-trusted-gpg-$K.gpg; done

# More readable
for KEY in $( \
    apt-key --keyring /etc/apt/trusted.gpg list \
    | grep -E "(([ ]{1,2}(([0-9A-F]{4}))){10})" \
    | tr -d " " \
    | grep -E "([0-9A-F]){8}\b" \
); do
    K=${KEY:(-8)} #Assign the last 8 characters to the variable K
    apt-key export $K | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/imported-from-trusted-gpg-$K.gpg #Export the key that matches the signature in K and pass/pipe it to gpg to properly store it
done #Loop until all keys are processed


# More readable
#for KEY in $( \ #Cycle through each key suffix, placing the current suffix in the KEY variable
#    apt-key --keyring /etc/apt/trusted.gpg list \ #Retrieve the list of known keys:
#    | grep -E "(([ ]{1,2}(([0-9A-F]{4}))){10})" \ #Find all groupings of hexadecimal characters that have 1 or 2 spaces in front of them, and are 4 characters long. Get the collection of those that have 10 groupings per line. This provides the full key>
#    | tr -d " " \ #Trim away (delete) all spaces on each line found, so that key signature is unbroken by white space
#    | grep -E "([0-9A-F]){8}\b" \ #Grab the last 8 characters of each line
#); do
#    K=${KEY:(-8)} #Assign the last 8 characters to the variable K
#    apt-key export $K | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/imported-from-trusted-gpg-$K.gpg #Export the key that matches the signature in K and pass/pipe it to gpg to properly store it
#done #Loop until all keys are processed
