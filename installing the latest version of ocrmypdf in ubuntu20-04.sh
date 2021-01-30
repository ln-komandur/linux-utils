# Reference https://ocrmypdf.readthedocs.io/en/latest/installation.html
ocrmypdf --version # check the initial version

sudo apt-get -y remove ocrmypdf  # remove system ocrmypdf, if installed
ocrmypdf --version # check that ocrmypdf is completely removed

sudo apt-get -y update
sudo apt-get -y install     ghostscript     icc-profiles-free     liblept5     libxml2     pngquant     python3-pip     tesseract-ocr     zlib1g

pip3 install --upgrade pip
sudo pip3 install ocrmypdf
sudo ln -s /usr/bin/local/ocrmypdf /usr/bin/ocrmypdf

ocrmypdf --version # check that the latest version is installed
