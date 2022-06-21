#!/bin/bash  

Banner() {
    echo -e "${CYN}Usage: ${0} <HTTPS_Domain_FileName>${END}"   
    exit 0
}

BLCheck() {
    mkdir BrokenLinkCheck
    while read DOMAIN
    do
        FNAME=`echo $DOMAIN | sed -e 's/http:\/\///g' -e 's/https:\/\///g' -e 's/\/$//g'`
        lychee --timeout 20 --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:99.0) Gecko/20100101 Firefox/99.0" $DOMAIN -o BrokenLinkCheck/$FNAME
    done <$1
    echo "[*] Broken Link Check ..Done!!" 
}

## Main Function Starts Here  

if [ ${#} -eq 1 ]  
then
    BLCheck $1
else
    Banner
fi
