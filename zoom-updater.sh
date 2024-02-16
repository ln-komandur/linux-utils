#!/bin/bash
#ref: https://community.zoom.com/t5/Meetings/Update-Zoom-in-Debian-Ubuntu/m-p/32820/highlight/true

#ref: https://unix.stackexchange.com/questions/28791/prompt-for-sudo-password-and-programmatically-elevate-privilege-in-bash-script
#ref: https://askubuntu.com/a/30157/8698

if (($EUID != 0)); then
  if [[ -t 1 ]]; then
#https://unix.stackexchange.com/questions/218715/what-does-t-1-do
    sudo "$0" "$@"
  else
    exec 1>output_file
    gksu "$0 $@"
  fi
  exit
fi


installed_ver=$(cat /opt/zoom/version.txt)
hosted_ver=$(wget --spider https://zoom.us/client/latest/zoom_amd64.deb 2>&1 | grep Location | sed -e 's/.*prod\/\(.*\)\/.*/\1/')
echo Installed: $installed_ver
echo Hosted: $hosted_ver

if [ $installed_ver = $hosted_ver ]; then
    echo "You have the latest version"
    exit 1;
fi

downloaded_file_name=zoom_amd64_$hosted_ver.deb

response=Y
echo -n "Download and install zoom version" $hosted_ver "over" $installed_ver "[Y/n]?"
read response
echo "Response is " $response


if [ $response = Y ] || [ $response == y ] || [ -z $response ] ; then
   wget -c https://zoom.us/client/latest/zoom_amd64.deb -O ./Downloads/$downloaded_file_name
   echo "###### Downloaded" $downloaded_file_name ". Installing now ######"
   apt install ./Downloads/$downloaded_file_name
else
   echo "Retaining "$installed_ver". Exiting."
fi
exit
