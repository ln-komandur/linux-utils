# This script disables unnecessary services to speed up boot process. It must be run as 'sudo'


echo "Stopping and Disabling NetworkManager-wait-online.service"
systemctl stop NetworkManager-wait-online.service
systemctl disable NetworkManager-wait-online.service

echo "Stopping and Disabling plymouth-quit-wait.service"
systemctl stop plymouth-quit-wait.service
systemctl disable plymouth-quit-wait.service

echo "Stopping and Disabling ModemManager.service"
systemctl stop ModemManager.service
systemctl disable ModemManager.service

echo "Stopping and Disabling ofono.service (IF Installed)"
systemctl stop ofono.service
systemctl disable ofono.service

