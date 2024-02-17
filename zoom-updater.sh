#!/bin/bash
#ref: https://community.zoom.com/t5/Meetings/Update-Zoom-in-Debian-Ubuntu/m-p/32820/highlight/true

installed_ver=$(cat /opt/zoom/version.txt)
hosted_ver=$(wget --spider https://zoom.us/client/latest/zoom_amd64.deb 2>&1 | grep Location | sed -e 's/.*prod\/\(.*\)\/.*/\1/')

if [ "$installed_ver" = "$hosted_ver" ]; then
    echo The latest zoom version $installed_ver is already installed. Exiting.
    exit 1;
fi

deb_destn_path="./Downloads/"zoom_amd64_${hosted_ver//\./-}.deb #Replace all '.'s with '-'s in the version number
response=Y

if [ -z "$installed_ver" ] ; then
    echo -------- No installed version found. Downloading and installing zoom version $hosted_ver --------
else
    echo -n Download and install zoom version $hosted_ver over $installed_ver [Y/n]?
    read response
fi

if [ "$response" = Y ] || [ "$response" == y ] || [ -z "$response" ] ; then
    wget -c https://zoom.us/client/latest/zoom_amd64.deb -O $deb_destn_path
    echo -------- Downloaded to $deb_destn_path . Installing now --------
else
    echo -------- Retaining zoom version $installed_ver. Exiting. --------
    exit 1;
fi

if ! sudo nala install $deb_destn_path; then # Use Apt if nala is not installed
     sudo apt install $deb_destn_path
fi

exit
