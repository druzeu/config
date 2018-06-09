#! /bin/bash
## DESCRIPTION
## For Amazon EC2 Instances
## Use curl to update a dynamic dns entry for http://afraid.org
## based on http://forums.gentoo.org/viewtopic-t-468368.html
## 
## INSTRUCTIONS 
## FIRST, change DIRECT_URL (below) based on http://freedns.afraid.org/dynamic/ 
## THEN, it doesn't hurt to do the following (change permissions)
## chmod 500 /etc/cron.d/afraid.aws.sh
## sudo chown root.root /etc/cron.d/afraid.aws.sh
## NEXT, move this file to /etc/cron.d, 
## FINALLY, add the following line to /etc/crontab
## */2 * * * * root /etc/cron.d/afraid.aws.sh >/dev/null

OLDIP_FILE="/tmp/ip.tmpfile"
## this is from within an instance, just returns instance public IP
## See http://docs.amazonwebservices.com/AWSEC2/latest/UserGuide/using-instance-addressing.html#concepts-instance-addressing for details
CHECK_CMD="curl -s ipinfo.io/ip"
## Find this at http://freedns.afraid.org/dynamic/
DIRECT_URL="http://freedns.afraid.org/dynamic/update.php?c1htb0Jja1p1emdxVUNJRm4zODZCRkU1OjE3NjA3ODc2"
UPDATE_COMMAND="/usr/bin/curl -s $DIRECT_URL"

echo "Getting current IP"
CURRENTIP=`${CHECK_CMD}`
echo "Found ${CURRENTIP}"

if [ ! -e "${OLDIP_FILE}" ] ; then
echo "Creating ${OLDIP_FILE}"
echo "0.0.0.0" > "${OLDIP_FILE}"
fi

OLDIP=`cat ${OLDIP_FILE}`

if [ "${CURRENTIP}" != "${OLDIP}" ] ; then
echo "Issuing update command"
${UPDATE_COMMAND}
fi

echo "Saving IP"
echo "${CURRENTIP}" > "${OLDIP_FILE}"
