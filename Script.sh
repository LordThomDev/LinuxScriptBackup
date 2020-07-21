#!/bin/sh

# Linux Backup Script by LordThom
# Contact: contact@lordthom.fr


########################
# Edit this section    #
########################

USERNAME="root"
PASSWORD="PassHere"
IP="xx.xx.xx.xx"
PORT="21"

DIR="/home"
REMOTEDIR="./archives"

#Name of the backup BACKUPNAME that will be in your FTP. DO NOT WRITE EXTENSIONS!
BACKUPNAME="BACKUP_Name"

#Type of transfert
#1=FTP
#2=SFTP
TYPE=1

##############################
# Don't Edit This            #
##############################

d=$(date --iso)

remove_temp_backup() {
  rm -f ./$BACKUPNAME
  echo 'Temp Backup Removed !'
}

BACKUPNAME=$BACKUPNAME"_"$d".tar.gz"
tar -czvf ./$BACKUPNAME $DIR
echo 'Tar OK'

if [ $TYPE -eq 1 ]
then
ftp -n -i $IP $PORT <<EOF
user $USERNAME $PASSWORD
binary
put $BACKUPNAME $REMOTEDIR/$BACKUPNAME
quit
EOF
elif [ $TYPE -eq 2 ]
then
sudo rsync --rsh="sshpass -p $PASSWORD ssh -p $PORT -o StrictHostKeyChecking=no -l $USERNAME" $BACKUPNAME $IP:$REMOTEDIR
else
echo 'Select a valid number, 1 (FTP) or 2 (SFTP)'
fi

echo 'Done'
remove_temp_backup
