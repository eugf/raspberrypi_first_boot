#!/bin/bash
#UPDATED: 20200422
#eugf/raspberrypi_first_boot
#NOTE: This is very much a WIP at the moment, I'm filling out the skeleton of this script and it's nowhere near ready for production

echo "#################################################"
echo "~~~~~~~~~~~~~~~~~~INITIALIZING~~~~~~~~~~~~~~~~~~"
echo "#################################################"

#TODO: Change keyboard localization ASAP (it's set to GB by default)
#read -p "Raspberry Pi keyboard layout defaults to Great Britain. Please run the command 'sudo raspi-config' before continuing and change the keyboard settings to match your layout. Have you already run this? (y/n)" YESNO

#TODO: nested if loops, or check up how to take y/n responses
if [ $YESNO == y ]; then
  echo "You may proceed"
elif [ $YESNO == n ]; then
  echo "Starting Raspberry Pi configuration"
  sudo raspi-config
else
  echo "Please try again"
  exit
fi

#TODO: can I automate this part?
#This works for me:
#4 Localisation Options > I3 Change Keyboard Layout > Generic 105-key PC (intl.) > Other > English (US) > The default for the keyboard layout > No compose key > No > TAB > TAB > Finish

#Name the new user account
read -p "Enter new username: " MYNAME

#Give new user account a password
read -p "Enter password: " MYPASS1
read -p "Please confirm password: " MYPASS2

#Check if passwords match
if [ $MYPASS1 == $MYPASS2 ]; then
  echo "Password confirmed!"
else
  echo "Please try again"
  exit
#  read -p "Enter password: " MYPASS1
#  read -p "Please confirm password: " MYPASS2
  #TODO: figure a better way to do this loop, elif back in if it fails, else exit after 3x
fi

#Create new user account and password
sudo adduser $MYNAME
#TODO: enter the password 2x, enter 5x, Y
echo "Your new account has been created"

#Upgrade new user acount with sudo permissions
sudo usermod -a -G adm,dialout,cdrom,sudo,audio,video,plugdev,games,users,input,netdev,gpio,i2c,spi $MYNAME

#Test if sudo works for new user account
sudo su - $MYNAME
if [ $(whoami) == $MYNAME ]; then
  echo "Sudo permissions granted"
else
  echo "Sudo permissions failed, please try again"
  exit
fi

#Cleanup procedures
#Kill pi user
sudo pkill -u pi

#
#
#

#TODO: logout, reboot, login to new user account
#TODO: How to have variables survive a reboot? otherwise they will be cleared upon terminal exit, and how to have the script run upon next boot just once? Might split this part off as a part2 if I can't
sudo reboot
#Delete the default pi user
sudo deluser pi
#Remove pi home directory
sudo deluser -remove-home pi

#Require new user to login with password
sudo nano /etc/sudoers.d/010_pi-nopasswd
#TODO: change this line to have your new username
#I'd say sudo touch command to create a new file and replace it
#$MYNAME ALL=(ALL) PASSWD: ALL
#TODO: delete any files this script created
#exit
