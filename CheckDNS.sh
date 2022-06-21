#!/bin/bash 

Banner() {
    echo "Usage: ${0} <domain_name>"
    exit
}

GetInfo() {
    # print IP address
    host $1 | egrep -o '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' | xargs -i echo "[+] {}"
    # getting first ip for whois check
    GetIp=`host $1 | egrep -m1 -o '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b'`
    OrgName=`whois $GetIp | grep -m1 'OrgName'`
    if [ ! -z "$OrgName" ]
    then 
        echo "[+] ${OrgName}"
    fi
}

# Global vars
DOMAIN=$1

if [ ${#} -eq 1 ]
then
    GetInfo $DOMAIN
else
    Banner
fi
