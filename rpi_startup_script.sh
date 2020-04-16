#!/bin/bash
#eugf/raspberrypi_first_boot
#Updated: 20200416

echo "#################################################"
echo "~~~~~~~~~~~~~~~~~~INITIALIZING~~~~~~~~~~~~~~~~~~"
echo "#################################################"

#Name the new user account
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
