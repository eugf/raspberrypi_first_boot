#!/bin/bash
#eugf/raspberrypi_first_boot
#Updated: 20200416

echo "#################################################"
echo "~~~~~~~~~~~~~~~~~~INITIALIZING~~~~~~~~~~~~~~~~~~"
echo "#################################################"

#read my_name
sudo adduser $my_name
sudo usermod -a -G adm,dialout,cdrom,sudo,audio,video,plugdev,games,users,input,netdev,gpio,i2c,spi $my_name
#Test if sudo works
sudo su - $my_name
sudo pkill -u pi
#logout, login to new user
#???
sudo deluser pi
sudo deluser -remove-home pi
sudo nano /etc/sudoers.d/010_pi-nopasswd

#Then change this line to have your new username
#I'd say sudo touch to create a new file and replace it
#$my_name ALL=(ALL) PASSWD: ALL

read pass1
#echo "Please confirm password"
read pass2
#check match???
#echo 
#passwd $pass2
echo "Your new password has been set"
