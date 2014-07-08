_currentDir="`pwd`"

clear

echo -e "\e[1;31mInstalling PyQt4...\n\e[0m"
sudo apt-get install build-essential python2.7-dev libxext-dev qt4-dev-tools python-sip python-sip-dev python-qt4 python-qt4-dev pyqt4-dev-tools

echo -e "\e[1;31m\nInstalling Octave...\n\e[0m"
sudo apt-get install octave octave-signal octave-statistics octave-geometry

echo -e "\e[1;31m\nInstalling PyUSB and Oct2Py...\n\e[0m"
sudo apt-get install python-pip
sudo pip install pyusb oct2py

echo -e "\e[1;31m\nInstalling PyCrypto, NumPy, SciPy, Matplotlib and enum ...\n\e[0m"
sudo apt-get install python-pycryptopp python-numpy python-scipy python-matplotlib python-enum

echo -e "\e[1;31m\nInstalling pyqt4-dev-tools ...\n\e[0m"
sudo apt-get install pyqt4-dev-tools

echo -e "\e[1;31m\nInstalling gspread ...\n\e[0m"
sudo pip install gspread

echo -e "\e[1;31m\nDependencies are successfully installed.\n\e[0m"
cd "$_currentDir"
