#!/bin/bash
#UPDATED: 20200422
#eugf/raspberrypi_first_boot
#NOTE: This is very much a WIP at the moment, I'm filling out the skeleton of this script and it's nowhere near ready for production

echo "#################################################"
echo "~~~~~~~~~~~~~~~~~~INITIALIZING~~~~~~~~~~~~~~~~~~"
echo "#################################################"

#SECTION WORKS -- TESTED -- REMOVE LATER
#Change keyboard localization ASAP (it's set to GB by default)
read -p "Raspberry Pi keyboard layout defaults to Great Britain (GB). Are you in GB? If not in GB, please enter no and change keyboard layout to match yours. (y/n) " YESNO
if [ $YESNO == y ]; then
  echo "You may proceed"
elif [ $YESNO == n ]; then
  echo "Starting Raspberry Pi configuration"
  sleep 1
  sudo raspi-config
else
  echo "Please try again"
  sleep 10
  exit
fi

#SECTION WORKS -- TESTED -- REMOVE LATER
#TODO: Automate this to override the above question?
#Minimum raspi-config needed to change keyboard to US layout
layout=us
sudo raspi-config nonint do_configure_keyboard $layout

#SECTION WORKS -- TESTED -- REMOVE LATER
#Name the new user account
read -p "Enter new username: " MYNAME

#SECTION WORKS -- TESTED -- REMOVE LATER
#Give new user account a password
MYPASS1=1
MYPASS2=2
while [ $MYPASS1 != $MYPASS2 ]
do
  echo "Please enter desired password for new user account"
  read -p "Enter password: " MYPASS1
  read -p "Confirm password: " MYPASS2
  if [ $MYPASS1 == $MYPASS2 ]; then
    echo "Password confirmed"
    sleep 1
    break
  fi
done

#TODO: needs more work below
#Create new user account and password
sudo adduser $MYNAME
#TODO: enter the password 2x, enter 5x, Y
echo "Your new account has been created"

#SECTION WORKS -- TESTED -- REMOVE LATER
#Upgrade new user acount with sudo permissions
sudo usermod -a -G adm,dialout,cdrom,sudo,audio,video,plugdev,games,users,input,netdev,gpio,i2c,spi $MYNAME
#Test if sudo works for new user account
sudo su - $MYNAME
if [ $(whoami) == $MYNAME ]; then
  echo "Sudo permissions granted"
else
  echo "Sudo permissions failed, please try again"
  sleep 10
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
#echo "You are now setup, exiting in 10 seconds"
#sleep 10
#exit
