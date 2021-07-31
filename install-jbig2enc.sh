# Install jbig2 encoding in Ubuntu or Lubuntu 20.04
git clone https://github.com/agl/jbig2enc
cd jbig2enc/
sudo apt install build-essential automake autotools-dev libtool
sudo apt install libleptonica-dev libjpeg8-dev libpng-dev libtiff5-dev zlib1g-dev
./autogen.sh
./configure 
./configure && make
sudo make install
