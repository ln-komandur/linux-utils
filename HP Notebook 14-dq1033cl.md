# HP Notebook 14-dq1033cl
## Handling Hardware Airplane mode issues in Ubuntu 22.04 

### [Add a service for HP keycodes](https://ubuntuhandbook.org/index.php/2022/04/disable-automatic-airplane-mode-ubuntu/)

Create a file to map e057 and e058 scancodes to no operation keycode 240

```
sudo tee -a /etc/systemd/system/hp-keycodes.service <<EOF
[Unit]
Description=Fix for HP Hardware-Airplane-Mode key codes

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

`reboot` #if required and check if Fn + F12 key works

## Undoing changes:

`sudo systemctl disable hp-keycodes.service` #disable the service:

`sudo rm /etc/systemd/system/hp-keycodes.service` #Remove the file

`reboot` #if required to apply changes
