#!/bin/sh

GRP_NAME=$FTP_USER
if getent group $GID; then
	GRP_NAME=$(getent group $GID | cut -d: -f1)
else
	addgroup \
		-g $GID \
		-S \
		$GRP_NAME
fi

adduser \
	-D \
	-G $GRP_NAME \
	-h /home/$FTP_USER \
	-s /bin/false \
	-u $UID \
	$FTP_USER

#mkdir -p /home/$FTP_USER
#chown -R $FTP_USER:$FTP_USER /home/$FTP_USER
echo "$FTP_USER:$FTP_PASS" | /usr/sbin/chpasswd

touch /var/log/vsftpd.log
tail -f /var/log/vsftpd.log | tee /dev/stdout &
touch /var/log/xferlog
tail -f /var/log/xferlog | tee /dev/stdout &

/usr/sbin/vsftpd
