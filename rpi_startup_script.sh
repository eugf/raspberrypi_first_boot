#!/bin/bash
#eugf/raspberrypi_first_boot
#Updated: 20200418
#NOTE: This is very much a WIP at the moment, I'm filling out the skeleton of this script and it's nowhere near ready for production

echo "#################################################"
echo "~~~~~~~~~~~~~~~~~~INITIALIZING~~~~~~~~~~~~~~~~~~"
echo "#################################################"

#TODO: Change keyboard localization ASAP, it's currently set to GB
echo "Please run the command 'sudo raspi-config' prior to running this script and change the keyboard settings"
#TODO: option to run it here???
#This works for me:
#4 Localisation Options > I3 Change Keyboard Layout > Generic 105-key PC (intl.) > Other > English (US) > The default for the keyboard layout > No compose key > No > TAB > TAB > Finish

#Name the new user account
echo "Enter new username: "
read my_name

#Give new user account a password
echo "Enter password:"
read pass1
echo "Please confirm password:"
read pass2
#TODO: check match???
#echo match/not

#Create new user account and password
sudo adduser $my_name
#TODO: enter the password 2x, enter 5x, Y
echo "Your new account has been created"

#Upgrade new user acount with sudo permissions
sudo usermod -a -G adm,dialout,cdrom,sudo,audio,video,plugdev,games,users,input,netdev,gpio,i2c,spi $my_name
#Manual test to see if sudo works
sudo su - $my_name
#Check that sudo works for new user account
if [$whoami == $my_name]
then
  echo "Sudo permissions granted"
else
  echo "Sudo permissions failed, please try again"
  #TODO: exit script
fi

#Cleanup procedures
#Kill pi user
sudo pkill -u pi
#TODO: logout, reboot, login to new user account
#Delete the default pi user
sudo deluser pi
#Remove pi home directory
sudo deluser -remove-home pi

#Require new user to login with password
sudo nano /etc/sudoers.d/010_pi-nopasswd
#TODO: change this line to have your new username
#I'd say sudo touch command to create a new file and replace it
#$my_name ALL=(ALL) PASSWD: ALL
