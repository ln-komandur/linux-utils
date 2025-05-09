# Installing phonetic Keyboards for Indian languages in addition to the default English Keyboard

## References - Links to itrans (m17n) phonetic key maps
1. [Tamil - itrans (m17n)](https://fedoraproject.org/wiki/I18N/Indic/TamilKeyboardLayouts)
2. [Sanskrit - itrans (m17n)](https://help.keyman.com/keyboard/itrans_devanagari_sanskrit_vedic/1.2.1/itrans_devanagari_sanskrit_vedic)

## Ubuntu with GNOME
1. There is **no need to install any language support** . But on a fresh installation, language packages may not be installed fully. You will be prompted when you go to Settings -> Region & Language. Install it and then `reboot` the PC (or logout and login) before proceeding to the next step

![Alt text](Language%20Support%20Not%20installed-Ubuntu-22-04.png "Language Support Not installed-Ubuntu-22-04.png")

2. You may have to execute the commands below and then install ***itrans(m17n)*** keyboards for Tamil and Sanskrit. They are both phonetic
    1. `sudo apt --fix-broken install` # *to fix any broken packages*
    2. `sudo apt-get install ibus` # *if ibus isn't installed already*
    3. `sudo apt-get install ibus-m17n`  # *if ibus-m17n isn't installed already as is possible in a fresh install of 24.04*

### Settings in Ubuntu 20.04.5 LTS with GNOME 3.36.8
![Alt text](Multi-Keyboard%20support%20in%20Ubuntu%2020-04-5.png "Multi-Keyboard support in Ubuntu 20-04-5")

### Settings in Ubuntu 22.04.2 LTS with GNOME 42.5
![Alt text](Multi-Keyboard%20support%20in%20Ubuntu%2022-04-2.png "Multi-Keyboard support in Ubuntu 20-04-5")

## Lubuntu 20.04.2 LTS with LxQt 0.14.1

1. Install IBus if it is not already installed
    1. `sudo apt-get install ibus`
    1. `sudo apt --fix-broken install`

1. Open the "Discover (Software Center)" & Install "Language Support" app

   ![Alt text](Discover%20-%20Language%20Support.jpg "Discover - Language Support")

1. Go to "Preference" and open the "Language Support" app
    1. Select the Keyboard input method as "IBus"
   
       ![Alt text](Language%20Support%20-%20Language%20tab.jpg "Language Support - Language tab")
    1. Install Languages needed. e.g. Tamil, Hindi (this is for Sanskrit also)

       ![Alt text](Language%20Support%20-%20Installed%20Languages.jpg "Language Support - Installed Languages")
    

1. Go to "Preference" and open the "IBus Preferences" app
    1.  Go to the "Input Method" tab and add the required Keyboards for the languages. e.g. Tamil - itrans (m17n), Sanskrit - itrans (m17n)
        1. ![Alt text](IBus%20Input%20Method%20tab.jpg "IBus Input Method tab")
        2. ![Alt text](Select%20Language%20popup.jpg "Select Language Popup")
    1.  In the General tab, configure shortcuts

        ![Alt text](IBus%20General%20tab.jpg "IBus General tab")
    1.  In the "Advanced" tab, check "Use System Keyboard Layout"

        ![Alt text](IBus%20Advanced%20tab.jpg "IBus Advanced tab")
