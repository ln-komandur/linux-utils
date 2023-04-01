# HP Notebook 14-dq1033cl
## Handling Hardware Airplane mode issues in Ubuntu 22.04 

### [Add a service for HP keycodes for Fn + F12 key press](https://askubuntu.com/questions/965595/why-does-airplane-mode-keep-toggling-on-my-hp-laptop-in-ubuntu-18-04)

Create a file to map e057 and e058 scancodes to no operation keycode 240

```
sudo tee -a /etc/systemd/system/hp-keycodes.service <<EOF
[Unit]
Description=Map HP Hardware Airplane Mode key codes

[Service]
Type=oneshot
Restart=no
RemainAfterExit=no
ExecStart=/usr/bin/setkeycodes e057 240 e058 240

[Install]
WantedBy=rescue.target
WantedBy=multi-user.target
WantedBy=graphical.target
EOF
```

`sudo systemctl daemon-reload && sudo systemctl enable hp-keycodes.service` #Reload the daemon and enable the service

`reboot` #if required and check if Fn + F12 key works with key code changes, and if airplane mode doesnt enable on lid close

### Set HandleLidSwitch=ignore to avoid sleeping when closing lid

`cat /etc/systemd/logind.conf | grep ^\#HandleLidSwitch=suspend` #Check if HandleLidSwitch=suspend is commented

`sudo sed -i 's/^\#HandleLidSwitch=suspend/HandleLidSwitch=ignore/g' /etc/systemd/logind.conf` #[Change to HandleLidSwitch=ignore and enable it](https://tipsonubuntu.com/2018/04/28/change-lid-close-action-ubuntu-18-04-lts/)

`systemctl restart systemd-logind.service` #Skip this if rebooting


### Undoing changes (Remove HP keycodes and service)

`sudo systemctl disable hp-keycodes.service` #disable the service:

`sudo rm /etc/systemd/system/hp-keycodes.service` #Remove the file

`reboot` #if required to apply changes

### Set HandleLidSwitch=suspend

`cat /etc/systemd/logind.conf | grep ^HandleLidSwitch=ignore` #Check if HandleLidSwitch=ignore is uncommented

`sudo sed -i 's/^HandleLidSwitch=ignore/\#HandleLidSwitch=suspend/g' /etc/systemd/logind.conf` #Change to HandleLidSwitch=suspend and disable it

`systemctl restart systemd-logind.service` #Skip this if rebooting