#! /bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# These settings should be defined before setup.


# read settings
# define install location, bed_size(x,y,z), auto_ejection(true/false), material_type, material_color

# install dependencies
sudo apt-get install screen 
sudo apt-get install software-properties-common 
sudo apt-get install git 
sudo apt-get install python-serial 
sudo apt-get install python-wxgtk2.8
sudo apt-get install python-pyglet
sudo apt-get install python-numpy
sudo apt-get install cython 
sudo apt-get install python-libxml2
sudo apt-get install python-gobject 
sudo apt-get install python-dbus
sudo apt-get install python-psutil
sudo apt-get install python-cairosvg 
sudo apt-get install python-pip
sudo apt-get install libpython-dev 
sudo apt-get install figlet


# install python

# create directory for working files
cd /


# get Printrun from Github and compile.
git clone https://github.com/SparkMakerspace/Printrun.git autodrop
cd Printrun
pip install -r requirements.txt
python setup.py build_ext --inplace
cd ..

#clone and build WiringPi
sudo apt purge wiringpi
hash -r
sudo apt update
sudo apt upgrade
cd /autodrop/
git clone git://git.drogon.net/wiringPi
cd wiringPi
git pull origin
./build



#setup reboot at end of script
cp /autodrop/start.sh /etc/init.d/autodrop-start.sh
chmod 755 /etc/init.d/autodrop-start.sh
sudo update-rc.d autodrop-start.sh defaults
chmod +x /autodrop/*.sh


pip install -r requirements.txt

