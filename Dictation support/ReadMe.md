# Dictation support using [nerd-dictation](https://github.com/ideasman42/nerd-dictation) and [vosk](https://alphacephei.com/vosk/)

# Installing for one user

**Reference:** [nerd-dictation installation](https://github.com/ideasman42/nerd-dictation?tab=readme-ov-file#install). *But do not use this as-is*

## Install xdotool
**Login** as `su <superuser>` and execute

`sudo nala install xdotool` #Install xdotool as it does not ship default in Ubuntu 22.04

**Logout** of `<superuser>` with an `exit`

## Install vosk
**Login** as the `<user>` who needs `nerd-dictation` installed

This [installation script for vosk and nerd-dictation](install%20vosk_nerd-dictation.sh) only installs them for that single `<user>`. 

The `<user>` must login with XOrg for this to work as this method uses the `xdotool`.


![Login with Xorg](Login%20with%20Xorg.png)


Follow [these instructions if using ydotool and to be independent of X Server](https://github.com/ideasman42/nerd-dictation/blob/main/readme-ydotool.rst)


The following warning is expected in this approach. 
```
 WARNING: The script vosk-transcriber is installed in '~/.local/bin' which is not on PATH.
  Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
```
It is addressed by ensuring that `~/.local/bin` is prepended to the `$PATH` variable for the `<user>`

### Starting the listener

`cd ~/.config/nerd-dictation`

`./nerd-dictation begin --vosk-model-dir=./model &` #Run as a background process

Start speaking into any application like a Text Editor, LibreOffice writer etc. You will notice the mic icon come on and your speech showing up as words on your text editor.


### Stopping the listener

`cd ~/.config/nerd-dictation`

`./nerd-dictation end` #Stops the listener

## More instructions
Once successful, you can try more instructions from [nerd-dictation installation](https://github.com/ideasman42/nerd-dictation?tab=readme-ov-file#install)

## Using Command Menu Gnome Extension

**Reference:** This video [Simple Dictation Software for Linux](https://youtu.be/Cw1SESc8sdA) shows **Command Menu** *Gnome Extension* being used

Install **Command Menu** from **Extension Manager**

![Extension Manager.png](Extension%20Manager.png)

Search for **arunk140** to find **Command Menu** and install it and turn it on with its switch

![Command Menu - search extension](Command%20Menu%20-%20search%20extn.png)

*Edit Commands*, add the following lines, save the file and *Reload* the **Command Menu** to get the *Nerd Dictation* commands in a sub-menu. The complete `.commands.json` [file is here](.commands.json)

``` ,
    {
        "title": "Nerd Dictation",
        "type": "submenu",
        "submenu": [
            {
                "title": "Begin",
                "command": "python3 .config/nerd-dictation/nerd-dictation begin",
                "icon": "media-record"
            },
            {
                "title": "End",
                "command": "python3 .config/nerd-dictation/nerd-dictation end",
                "icon": "media-playback-stop"
            },
            {
                "title": "Suspend",
                "command": "python3 .config/nerd-dictation/nerd-dictation suspend",
                "icon": "media-playback-pause"
            },
            {
                "title": "Resume",
                "command": "python3 .config/nerd-dictation/nerd-dictation resume",
                "icon": "media-forward"
            },
            {
                "title": "Cancel",
                "command": "python3 .config/nerd-dictation/nerd-dictation cancel",
                "icon": "media-rewind"
            }
        ]
    }
```

![Command Menu - edited with Submenu.png](Command%20Menu%20-%20edited%20with%20Submenu.png)


# Uninstalling for one user
Use this script to [uninstall vosk and nerd-dictation](uninstall%20vosk_nerd-dictation.sh) from the said `<user>`'s login



# Handling errors

## [Errno 13] Permission denied: '/tmp/nerd-dictation.cookie'

If you get an error as below
```
Traceback (most recent call last):
  File "/home/timepass/.config/nerd-dictation/./nerd-dictation", line 1974, in <module>
    main()
  File "/home/timepass/.config/nerd-dictation/./nerd-dictation", line 1970, in main
    args.func(args)
  File "/home/timepass/.config/nerd-dictation/./nerd-dictation", line 1835, in <lambda>
    func=lambda args: main_begin(
  File "/home/timepass/.config/nerd-dictation/./nerd-dictation", line 1316, in main_begin
    with open(path_to_cookie, "w", encoding="utf-8") as fh:
PermissionError: [Errno 13] Permission denied: '/tmp/nerd-dictation.cookie'
```
it is most likely because the `/tmp/nerd-dictation.cookie` file is owned by another user. Check who owns this file

`ls -l /tmp/nerd-dictation.cookie` #Check who owns this file

`rm /tmp/nerd-dictation.cookie` #And delete it. You may need `sudo` privileges to do this







