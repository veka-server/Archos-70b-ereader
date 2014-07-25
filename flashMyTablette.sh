#!/bin/bash
# Script de flashage de tablette RK28


#
#	$1 = fichier .img
#	$2 = Destination
#	
#

if [ $USER != root ]; then
echo "il faut etre root"
exit
fi 

checkTablette=`lsusb | grep "2207:281a" | wc -l`
if [ $checkTablette == 0 ]; then
echo "Tablette non reconnue, eteignez la, puis branchez le cable usb tout en maintenant enfoncer le bouton droit."
exit
fi 

clear

NORMAL="\033[0;39m" 
ROUGE="\033[1;31m" 
BLEU="\033[1;34m" 
GRIS='\033[1;30m'
VERT='\033[1;32m'

etape(){
	echo -n -e "$VERT"
	echo ":: " $1
	echo -n -e "$GRIS"
}

Flashage(){
	etape "Flashage du "$1
	var1=`cat /tmp/FMT/FULL/HWDEF  | grep $1 | sed "s/\s\+//g"  | sed "s/$1//g" | sed "s/:/%/g" | cut -d'%' -f1`
	var2=`cat /tmp/FMT/FULL/HWDEF  | grep $1 | sed "s/\s\+//g"  | sed "s/$1//g" | sed "s/:/%/g" | cut -d'%' -f2`
	sudo /home/veka/Script/android/rkflashtool w $var1 $var2 < /tmp/FMT/FULL/Image/$1.img 
	echo -n -e "$NORMAL"
}

etape "Preparation du script"

mkdir /tmp/FMT
cd /tmp/FMT

etape "Extraction de l'image"
afptool -unpack $1 FULL $2>/dev/null

sudo chmod -R 666 /dev/bus/usb/003/

# Flashage des differentes sous-image
Flashage misc
Flashage kernel
Flashage boot
Flashage recovery
Flashage system

etape "Nettoyage"
rm -R /tmp/FMT

etape "Reboot de la tablette"
sudo /home/veka/Script/android/rkflashtool b

echo -n -e "$NORMAL"
