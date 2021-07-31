# The following applies to Lubuntu 20.04.2 LTS with LxQt 0.14.1
## Installing phonetic Keyboards for Indian languages in addition to the default English Keyboard

1. Install IBus if it is not already installed
    1. `sudo apt-get install ibus`
    2. `sudo apt --fix-broken install`

3. Open the "Discover (Software Center)" & Install "Language Support" app

1. Go to "Preference" and open the "Language Support" app
    1. Install Languages needed. e.g. Tamil, Hindi (this is for Sanskrit also)
    2. Select the Keyboard input method as "IBus"

1. Go to "Preference" and open the "IBus Preferences" app
    1.  Go to the "Input Method" tab and add the required Keyboards for the languages. e.g. Tamil - itrans (m17n), Sanskrit - itrans (m17n)
    2.  In the General tab, configure short cuts
    3.  In the "Advanced" tab, check "Use System Keyboard Layout"
