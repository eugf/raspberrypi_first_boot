#!/bin/bash
#eugf/raspberrypi_first_boot
#Updated: 20200420
#NOTE: This is very much a WIP at the moment, I'm filling out the skeleton of this script and it's nowhere near ready for production

echo "#################################################"
echo "~~~~~~~~~~~~~~~~~~INITIALIZING~~~~~~~~~~~~~~~~~~"
echo "#################################################"

#TODO: Change keyboard localization ASAP (it's set to GB by default)
echo "Please run the command 'sudo raspi-config' prior to running this script and change the keyboard settings"
#TODO: option to run it here???
#This works for me:
#4 Localisation Options > I3 Change Keyboard Layout > Generic 105-key PC (intl.) > Other > English (US) > The default for the keyboard layout > No compose key > No > TAB > TAB > Finish

#Name the new user account
read -p "Enter new username: " MY_NAME

#Give new user account a password
read -p "Enter password: " MY_PASS1
read -p "Please confirm password: " MY_PASS2

#Check if passwords match
if [$MY_PASS1 == $MY_PASS2]
then
  echo "Password confirmed!"
else
  read -p "Enter password: " MY_PASS1
  read -p "Please confirm password: " MY_PASS2
  #TODO: CANCEL SCRIPT
fi

#Create new user account and password
sudo adduser $MY_NAME
#TODO: enter the password 2x, enter 5x, Y
echo "Your new account has been created"

#Upgrade new user acount with sudo permissions
sudo usermod -a -G adm,dialout,cdrom,sudo,audio,video,plugdev,games,users,input,netdev,gpio,i2c,spi $MY_NAME
#Test to see if sudo works
sudo su - $MY_NAME
#Check that sudo works for new user account
if [$whoami == $MY_NAME]
then
  echo "Sudo permissions granted"
else
  echo "Sudo permissions failed, please try again"
  #TODO: cancel script
fi

#Cleanup procedures
#Kill pi user
sudo pkill -u pi
#TODO: logout, reboot, login to new user account
sudo reboot
#Delete the default pi user
sudo deluser pi
#Remove pi home directory
sudo deluser -remove-home pi

#Require new user to login with password
sudo nano /etc/sudoers.d/010_pi-nopasswd
#TODO: change this line to have your new username
#I'd say sudo touch command to create a new file and replace it
#$MY_NAME ALL=(ALL) PASSWD: ALL
