#!/bin/bash 

## Current wordlist
WORDLIST="/root/tools/wordlists/small_wordlist.txt"

Banner() {
    echo -e "\nUsage: ${0} [Domains_List_File|Domain_Name] [-d <seconds>]"
    echo 
    echo -e "Example Usage : \n"
    echo -e "\t${0} Domains.txt"
    echo -e "\t${0} https://google.com"
    echo -e "\t${0} Domains.txt -d 1"
    echo -e "\t${0} https://google.com -d 1\n"
    echo "Possible second values are 1, 2, 3, 0.1, 0.2, 0.3, 0.4...."
    exit 0
}

StartDirBrute() {   
    echo "[!] Directory Bruteforce Started"
    mkdir Dirbruteforce
    cd Dirbruteforce
    while read -r url
    do 
        domain=${url##*/}
        ffuf -c -H "X-Forwarded-For: 127.0.0.1" -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:72.0) Gecko/20100101 Firefox/72.0" -u "$url/FUZZ" -t 50 -D -e js,php,bak,txt,asp,aspx,jsp,html,zip,jar,sql,json,old,gz,shtml,log,swp,yaml,yml,config,save,rsa,ppk -ac -se -w $WORDLIST -o $domain.json
        sed 's/content-type/contentType/g' $domain.json | jq '.results[]|"url:\(.url) status:\(.status) length:\(.length) [content-type:\(.contentType)] redirect:\(.redirectlocation)"' >> $domain.txt
        rm $domain.json
    done <../$1
    echo "[*] Directory Bruteforce Completed..!"
    echo "[!] Result Stored in 'Dribruteforce' Directory."
}

StartDirBruteDelay() {   
    echo "[!] Directory Bruteforce Started"
    mkdir Dirbruteforce
    cd Dirbruteforce
    while read -r url
    do 
        domain=${url##*/}
        ffuf -c -p $2 -H "X-Forwarded-For: 127.0.0.1" -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:72.0) Gecko/20100101 Firefox/72.0" -u "$url/FUZZ" -t 50 -D -e js,php,bak,txt,asp,aspx,jsp,html,zip,jar,sql,json,old,gz,shtml,log,swp,yaml,yml,config,save,rsa,ppk -ac -se -w $WORDLIST -o $domain.json
        sed 's/content-type/contentType/g' $domain.json | jq '.results[]|"url:\(.url) status:\(.status) length:\(.length) [content-type:\(.contentType)] redirect:\(.redirectlocation)"' >> $domain.txt
        rm $domain.json
    done <../$1
    echo "[*] Directory Bruteforce Completed..!"
    echo "[!] Result Stored in 'Dribruteforce' Directory."
}

SingleDomainBruteforce() {
    echo "[!] Directory Bruteforce Started" 
    domain=${1##*/}
    ffuf -c -H "X-Forwarded-For: 127.0.0.1" -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:72.0) Gecko/20100101 Firefox/72.0" -u "$1/FUZZ" -t 50 -D -e js,php,bak,txt,asp,aspx,jsp,html,zip,jar,sql,json,old,gz,shtml,log,swp,yaml,yml,config,save,rsa,ppk -ac -se -w $WORDLIST -o $domain.json
    sed 's/content-type/contentType/g' $domain.json | jq '.results[]|"url:\(.url) status:\(.status) length:\(.length) [content-type:\(.contentType)] redirect:\(.redirectlocation)"' >> $domain.txt
    rm $domain.json
    echo "[*] Directory Bruteforce Completed..!"
    echo "[!] Result Stored in $domain.txt file."
}

SingleDomainBruteforceDelay() {
    echo "[!] Directory Bruteforce Started" 
    domain=${1##*/}
    ffuf -c -p $2 -H "X-Forwarded-For: 127.0.0.1" -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:72.0) Gecko/20100101 Firefox/72.0" -u "$1/FUZZ" -t 50 -D -e js,php,bak,txt,asp,aspx,jsp,html,zip,jar,sql,json,old,gz,shtml,log,swp,yaml,yml,config,save,rsa,ppk -ac -se -w $WORDLIST -o $domain.json
    sed 's/content-type/contentType/g' $domain.json | jq '.results[]|"url:\(.url) status:\(.status) length:\(.length) [content-type:\(.contentType)] redirect:\(.redirectlocation)"' >> $domain.txt
    rm $domain.json
    echo "[*] Directory Bruteforce Completed..!"
    echo "[!] Result Stored in $domain.txt file."
}

## Main Function Starts Here  
# Check if subdomain file provided
# or single subdomain string
if [ ! -f "$1" ]
then
    if [ ${#} -eq 1 ]  
    then
        SingleDomainBruteforce $1
    elif [ ${#} -eq 3 ]
    then
        if [ "$2" == "-d" ]
        then 
            SingleDomainBruteforceDelay $1 $3
        fi
    else
        Banner
    fi
else 
    if [ ${#} -eq 1 ]  
    then
        StartDirBrute $1
    elif [ ${#} -eq 3 ]
    then
        if [ "$2" == "-d" ]
        then 
            StartDirBruteDelay $1 $3
        fi
    else
        Banner
    fi
fi
