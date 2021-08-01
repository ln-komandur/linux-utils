# The following applies to Lubuntu 20.04.2 LTS with LxQt 0.14.1
## Installing phonetic Keyboards for Indian languages in addition to the default English Keyboard

1. Install IBus if it is not already installed
    1. `sudo apt-get install ibus`
    1. `sudo apt --fix-broken install`

1. Open the "Discover (Software Center)" & Install "Language Support" app
    1. ![Alt text](Discover%20-%20Language%20Support.jpg "Discover - Language Support")

1. Go to "Preference" and open the "Language Support" app
    1. Select the Keyboard input method as "IBus"
        1. ![Alt text](Language%20Support%20-%20Language%20tab.jpg "Language Support - Language tab")
    1. Install Languages needed. e.g. Tamil, Hindi (this is for Sanskrit also)
        1. ![Alt text](Language%20Support%20-%20Installed%20Languages.jpg "Language Support - Installed Languages")
    

1. Go to "Preference" and open the "IBus Preferences" app
    1.  Go to the "Input Method" tab and add the required Keyboards for the languages. e.g. Tamil - itrans (m17n), Sanskrit - itrans (m17n)
        1. ![Alt text](IBus%20Input%20Method%20tab.jpg "IBus Input Method tab")
        2. ![Alt text](Select%20Language%20popup.jpg "Select Language Popup")
    1.  In the General tab, configure shortcuts
        1. ![Alt text](IBus%20General%20tab.jpg "IBus General tab")
    1.  In the "Advanced" tab, check "Use System Keyboard Layout"
        1. ![Alt text](IBus%20Advanced%20tab.jpg "IBus Advanced tab")