# Remote Desktop

## Reference

[How to Configure VNC and RDP on Ubuntu 22.04 | Remote Access, Screen Sharing](https://www.youtube.com/watch?v=m5U1PgqfGiA)

## Steps
1.  On the remote desktop intended to connect to *(server)*
    1.  Install the gnome extension **Allow Locked Remote Desktop** from *allowlockedremotedesktop@kamens.us* in *Extension Manager* to avoid terminating the connection when locking the remote desktop *(server)*
    1.  In Ubuntu 22.04, under **Settings**
        1.  turn on **Sharing**
        1.  turn on **Remote Desktop**
            1.  turn on **Remote Control** *only if intending to allow*
            1.  Under *Authentication* set-up a **User Name** and **Password** to authenticate the connection. *This is different from any user accounts on the remote desktop server*
    1.  In Ubuntu 24.04, under **Settings**, click **Remote Desktop** 
        1.  For **Desktop Sharing**, turn it on under that tab
            1.  turn on **Remote Control** *only if intending to allow*
            1.  Under *Login Details* set-up a **Username** and **Password** to authenticate the connection. *This is different from any user accounts on the remote desktop server*
        1.  For **Remote Login**, turn it on under that tab
            1.  turn on **Remote Login** *only if intending to allow*
            1.  Under *Login Details* set-up a **Username** and **Password** to authenticate the connection. *This is different from any user accounts on the remote login server*
1.  On the machine intended to connect from *(client)*
    1.  Install **Remmina** if not already installed
        1.  Configure **Remmina** settings
            1. **Name** - A name for the connection
            2. **Protocol** - RDP, or VNC if it was allowed on the server settings
            3. **Server** - dns name (very useful if using tailscale) or ip address
            4. **Username** - to authenticate the connection
            5. **Password** - to authenticate the connection
    1.  Click **Save and Connect**
