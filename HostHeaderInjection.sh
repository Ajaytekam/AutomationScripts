#!/bin/bash 

##
# Used Tools : httpxm, rush, xargs
##
G='\033[1;32m'
N='\033[0m'

Banner() {
    echo -e "\nUsage: ${0} [Domains_List_File|Domain_Name]"
    echo 
    echo -e "Example Usage : \n"
    echo -e "\t${0} SubDomains.txt"
    echo -e "\t${0} domain.com"
    echo -e "\nResult : Stored on 'HostHeaderInjection.txt'"
    exit 0
}

SingleDomainHHInjection() {
    echo -e "${G}[+]${N} Checking Domain.."   
    Domain=`echo $1 | httpx -follow-redirects -silent -no-color`
    temp=`echo $Domain | cut -d" " -f2`
    if [ "$temp" != "" ]
    then
        targetD=`echo $temp | sed -e 's/^\[//g' -e 's/\]$//g' | cut -d? -f1`
    else
        targetD=$Domain
    fi
    echo -e "${G}[+]${N} Checking for Host Header Injection on : ${targetD}"     
    echo $targetD | xargs -I{} sh -c 'curl -m5 -s -I -H "X-Forwarded-Host: evil.com" {} | [ $(grep -c "evil.com") -gt 0 ] && echo "\033[1;31m[*] {} : Vulnerable to Host Headr Injection \033[0m"' 2> /dev/null | tee HostHeaderInjection.txt 
    echo -e "${G}[+]${N} Test Completed...."    
}

MultiDomainHHInjection() {
    echo -e "${G}[+]${N} Checking Alive Subdomains.."   
    cat $1 | httpx -threads 50 -follow-redirects -silent -no-color >> tempSubDs
    while read line
    do 
        temp=`echo $line | cut -d" " -f2`
        if [ "$temp" != "" ]
        then 
            dat=`echo $temp | sed -e 's/^\[//g' -e 's/\]$//g'`
            echo $dat >> subDomainList
        else 
            echo $line >> subDomainList  
        fi
    done < tempSubDs
    echo -e "${G}[+]${N} Checking for Host Header Injection.."     
    cat subDomainList | rush -j200 'curl -m5 -s -I -H "X-Forwarded-Host: evil.com" {} | [[ $(grep -c "evil.com") -gt 0 ]] && echo -e "\033[1;31m[*] {} - [Vulnerable to Host Header Injection] \033[0m"' 2>/dev/null | tee HostHeaderInjection.txt
    echo -e "${G}[+]${N} Test Completed...."    
    rm tempSubDs
    rm subDomainList
}

## Main Function Starts Here  
# Check if subdomain file provided
# or single subdomain string
if [ ${#} -eq 1 ]
then
    if [ ! -f $1 ] 
    then
        SingleDomainHHInjection $1
    else
        MultiDomainHHInjection $1 
    fi
else 
    Banner
fi
