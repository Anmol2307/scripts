sudo apt-get update && sudo apt-get upgrade;
sudo apt-get install ubuntu-restricted-extras;
sudo apt-get install terminator;
sudo apt-get install flashplugin-installer;
sudo apt-get install nautilus-dropbox;
sudo apt-get install vlc;
sudo apt-get install git;
sudo apt-get install vim;

sudo apt-get install python-pip;
sudo apt-get install python-dev libxml2-dev libxslt-dev; //needed else gives pip gives some error that pyconfig.h is not present
sudo pip install virtual-env;
pip install cython;
sudo apt-get install ruby;
sudo apt-get install ruby-dev;
sudo gem install jekyll;
sudo gem install therubyracer;
sudo gem install execjs;

// 64 bit google chrome
sudo apt-get install libxss1 libappindicator1 libindicator7
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*.deb

// Sublime Text
sudo add-apt-repository ppa:webupd8team/sublime-text-3
sudo apt-get update
sudo apt-get install sublime-text-installer


