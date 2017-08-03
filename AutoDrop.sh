#!/bin/bash
# include this boilerplate

#These are all the settings for the printer. Change these 

printerServer='http://AUTODROP3D.COM/printerinterface/gcode'
printerName='JOHNSUCKS'
printerColor='RED'
printerMaterial='PLA'
SIZEX='50'
SIZEY='50'
SIZEZ='300'


function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}


TheTop:
clear
figlet AutoDrop3d.com
rm -f download.gcode
wget -O download.gcode "$printerServer?name=$printerName&Color=$printerColor&material=$printerMaterial&SizeX=$SIZEX&SizeY=$SIZEY&SizeZ=$SIZEZ"
rm -f printpage.txt
sed -n '2,10p' download.gcode >> printpage.txt

echo $printerName >> printpage.txt
echo "Printed on $(date)" >> printpage.txt

read -r PrintQueueInstruction<download.gcode

if test "$PrintQueueInstruction" == ";start" ; then
	clear
	figlet Starting Print
	jumpto PrintThePart
fi

echo $PrintQueueInstruction
sleep 10
jumpto TheTop
exit


PrintThePart:
PrintJobID=`sed -n '3p' download.gcode`


./printcore.py -b 76800 -v '/dev/ttyS0' start1.gcode
sleep 10
#this is to print the file
lpr printpage.txt


CheckPrintStaus:
figlet Wating For Printer

PrintStatus="$(lpq -a)"
if test "$PrintStatus" != "no entries" ; then
	jumpto CheckPrintStaus
fi


sleep 10

./printcore.py -b 76800 -v '/dev/ttyS0' start2.gcode
./printcore.py -b 76800 -v '/dev/ttyS0' download.gcode
sleep 10

./printcore.py -b 76800 -v '/dev/ttyS0' end.gcode


#report Print Job Completed
wget -O download.gcode "$printerServer?jobID=${PrintJobID:1}&stat=Done"

jumpto TheTop
