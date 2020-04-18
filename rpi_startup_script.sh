#!/bin/bash
#eugf/raspberrypi_first_boot
#Updated: 20200418
#NOTE: This is very much a WIP at the moment, I'm filling out the skeleton of this script and it's nowhere near ready for production

#TODO: This looks really bad on a VM, change?
echo "#################################################"
echo "~~~~~~~~~~~~~~~~~~INITIALIZING~~~~~~~~~~~~~~~~~~"
echo "#################################################"

#TODO: Change keyboard localization ASAP, it's currently set to GB
echo "Please run the command 'raspi-config' prior to running this script and change the keyboard settings"
#TODO: option to run it here???

#Name the new user account
echo "Enter new username: "
read $my_name
sudo adduser $my_name

#Give new user sudo permissions
sudo usermod -a -G adm,dialout,cdrom,sudo,audio,video,plugdev,games,users,input,netdev,gpio,i2c,spi $my_name

#Manual test to see if sudo works
sudo su - $my_name

#Kill pi user
sudo pkill -u pi

#TODO: logout, login to new user
#???

#Delete the default pi user, remove pi home directory
sudo deluser pi
sudo deluser -remove-home pi

#Require new user to login with password
sudo nano /etc/sudoers.d/010_pi-nopasswd
#TODO: Then change this line to have your new username
#I'd say sudo touch to create a new file and replace it
#$my_name ALL=(ALL) PASSWD: ALL

read pass1
#echo "Please confirm password"
read pass2
#check match???
#echo
#passwd $pass2
echo "Your new password has been set"
