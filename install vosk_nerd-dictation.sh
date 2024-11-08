echo
echo pip3 install vosk #Install vosk for a regular user. This will place it under the user's $HOME
pip3 install vosk #Install vosk for a regular user. This will place it under the user's $HOME

echo
echo . .profile #Set the PATH
. .profile

echo
echo PATH
echo $PATH

echo
echo cd .config/
cd .config/

echo
echo git clone https://github.com/ideasman42/nerd-dictation.git
git clone https://github.com/ideasman42/nerd-dictation.git

echo
echo cd nerd-dictation
cd nerd-dictation

echo
echo wget https://alphacephei.com/kaldi/models/vosk-model-small-en-us-0.15.zip #Get the basic model
wget https://alphacephei.com/kaldi/models/vosk-model-small-en-us-0.15.zip #Get the basic model

echo
echo unzip vosk-model-small-en-us-0.15.zip
unzip vosk-model-small-en-us-0.15.zip

echo
echo mv vosk-model-small-en-us-0.15 model
mv vosk-model-small-en-us-0.15 model
