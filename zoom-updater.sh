#!/bin/sh

echo Installed: $(cat /opt/zoom/version.txt)
echo Available: $(wget --spider https://zoom.us/client/latest/zoom_amd64.deb 2>>

REPLY=n
echo -n "Download and install? "
read REPLY
if [ $REPLY = y ] ; then
  wget -c https://zoom.us/client/latest/zoom_amd64.deb -P ./Downloads
  sudo apt install ./Downloads/zoom_amd64.deb
  rm ./Downloads/zoom_amd64.deb
fi
exit
