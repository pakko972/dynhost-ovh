#/bin/sh

#
# CONFIG
#
set -e

HOST=${DYNHOST_HOST}
LOGIN=${DYNHOST_LOGIN}
PASSWORD=${DYNHOST_PASS}

CURRENT_DATE=`date`

#
# GET IPs
#

HOST_IP=`dig +short $HOST`
CURRENT_IP=`curl -4 ifconfig.co`

#
# DO THE WORK
#
if [ -z $CURRENT_IP ] || [ -z $HOST_IP ]
then
  echo "No IP retrieved"
else
  if [ "$HOST_IP" != "$CURRENT_IP" ]
  then
    echo "$CURRENT_DATE"": Current IP:" "$CURRENT_IP" "and" "host IP:" "$HOST_IP" "   IP has changed!"
    RES=`curl --user "$LOGIN:$PASSWORD" "https://www.ovh.com/nic/update?system=dyndns&hostname=$HOST&myip=$CURRENT_IP"`
    echo "Result request dynHost:"
    echo "$RES"
  else
    echo "$CURRENT_DATE"": Current IP:" "$CURRENT_IP" "and" "Host IP:" "$HOST_IP" "   IP has not changed"
  fi
fi

