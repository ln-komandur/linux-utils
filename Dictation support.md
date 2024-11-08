# Dictation support using [nerd-dictation](https://github.com/ideasman42/nerd-dictation) and [vosk](https://alphacephei.com/vosk/)

**Caveat:** This will work well **only in the super user** login. If you start the listener in a terminal where you are logged in as a super user, but where you are logged into Gnome as a non super user, you will most likely get the error below

```
XDG_RUNTIME_DIR (/run/user/1001) is not owned by us (uid 1000), but by uid 1001! (This could e.g. happen if you try to connect to a non-root PulseAudio as a root user, over the native protocol. Don't do that.)
Connection failure: Connection refused
pa_context_connect() failed: Connection refused
```

## Installation

**Reference:** [nerd-dictation installation](https://github.com/ideasman42/nerd-dictation?tab=readme-ov-file#install). *But do not use this as-is*

### Install vosk
`sudo nala install xdotool` #Install xdotools as it does not ship default in Ubuntu 22.04

`sudo pip3 install vosk` #Install vosk as super user. This will place it in /usr/ .... rather than under the user's `$HOME` which is not desirable

 ### Install nerd-dictation

 **Note:** Remain in the super user login on your terminal
 
`cd .config/`

`git clone https://github.com/ideasman42/nerd-dictation.git`

`cd nerd-dictation`

`wget https://alphacephei.com/kaldi/models/vosk-model-small-en-us-0.15.zip` #Get the basic model

`unzip vosk-model-small-en-us-0.15.zip`

`mv vosk-model-small-en-us-0.15 model`

#### Start the listener
 
`./nerd-dictation begin --vosk-model-dir=./model &` #Run as a background process

Start speaking into any application like a Text Editor, LibreOffice writer etc. You will notice the mic icon come on and your speech showing up as words on your text editor.

#### [Errno 13] Permission denied: '/tmp/nerd-dictation.cookie'

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
it is most likely because the `/tmp/nerd-dictation.cookie` file is owned by another user, most likely a non super user because of playing from their login

`ls -l /tmp/nerd-dictation.cookie` #Check who owns this file

`sudo rm /tmp/nerd-dictation.cookie` #And delete it

#### Stop the listener

`./nerd-dictation end`

## More instructions
Once successful, you can try more instructions from [nerd-dictation installation](https://github.com/ideasman42/nerd-dictation?tab=readme-ov-file#install)

## Using Command Menu Gnome Extension

This video [Simple Dictation Software for Linux](https://youtu.be/Cw1SESc8sdA) show how to use the **Command Menu** *Gnome Extension*



