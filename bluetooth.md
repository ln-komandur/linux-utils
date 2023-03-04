## blueman prompt / error requiring every user to authenticate with sudo privilleges upon login

View `blueman.rules` with

`cat /usr/share/polkit-1/rules.d/blueman.rules`

```
// Allow users in sudo or netdev group to use blueman feature requiring root without authentication
polkit.addRule(function(action, subject) {
    if ((action.id == "org.blueman.network.setup" ||
         action.id == "org.blueman.dhcp.client" ||
         action.id == "org.blueman.rfkill.setstate" ||
         action.id == "org.blueman.pppd.pppconnect") &&
        subject.local && subject.active &&
        (subject.isInGroup("sudo") || subject.isInGroup("netdev"))) {
        return polkit.Result.YES;
    }
});

```

Confirm if the logged in user belongs to `netdev` group by executing 

`groups`

If not, include them in `netdev` group by executing

`sudo gpasswd -a ${USER} netdev` and check again by executing `groups`

### blueman gtk_icon_theme_get_for_screen warnings
1. Check for "gtk_icon_theme_get_for_screen: assertion 'GDK_IS_SCREEN (screen)' failed". Note: The service might have already failed to start. `systemctl status blueman-mechanism.service`
2. Stop if "gtk_icon_theme_get_for_screen: assertion 'GDK_IS_SCREEN (screen)' failed" is present `sudo systemctl stop blueman-mechanism.service`
3. Disable blueman-mechanism.service. Note: The service will still try to start and give the same error. But it will not hold up the boot process like before.
 `sudo systemctl disable blueman-mechanism.service` 
