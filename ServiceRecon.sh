#!/bin/bash 

Banner() {
    echo -e "${CYN}Usage: ${0} <massdns_Result_File>${END}"    
    exit 0
}

OPTemplateHEAD='<html><head><title>PortAndServices Scan Result</title><link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.1/css/jquery.dataTables.css"><script src="https://code.jquery.com/jquery-3.6.0.slim.min.js" integrity="sha256-u7e5khyithlIdTpu22PHhENmPcRdFiHRjhAuHcs05RI=" crossorigin="anonymous"></script><script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.11.1/js/jquery.dataTables.js"></script><style>h1{text-align: center;color: blue;}td{text-align: center;}</style></head><body><h1>Port and Service Scan Result</h1><table id="result" class="display" style="width:100%"></table><script>var dataSet = ['

OPTemplateTAIL='];$(document).ready(function(){$("#result").DataTable({data:dataSet,columns:[{title:"IP Address"},{title:"Domain|s"},{title:"Open Ports"},{title:"Scan Details"}]});});</script></body></html>'

ScanServices() {
    ### masscan 
    # get ip from massdnsResult file 
    cat $1 | egrep -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | sort -u | tee ips.txt
    # start masscan 
    masscan -iL ips.txt --rate 10000 --top-ports 1000 -oL masscanResults.txt
    # store the result on ip:port order
    cat masscanResults.txt | grep open | awk '{print $4":"$3}' | sort -u | tee parsedResult.txt
    # filter and sort the IP from parsedResult.txt file into a new file 
    cat parsedResult.txt | cut -d: -f1 | sort -u | tee aliveIPs.txt 
    # parse uniqe IPs and their port numbers in ip:port1,port2,port3...,portN format
    for ip in `cat aliveIPs.txt`
    do
        ports=`cat parsedResult.txt | grep $ip | cut -d: -f2`
        ptlist=`echo $ports`
        echo "$ip:$ptlist" | tr " " , >> ip_ports.txt
    done
    # nmap scan from file ip_ports.txt
    echo $OPTemplateHEAD >> result.html 
    mkdir results
    while IFS=: read -r ip ports
    do
        nmap -sV -p$ports $ip -oN results/$ip
        # grep domains 
        DOMAINSTEMP=`cat massdnsResults.txt | grep $ip | awk '{print $1}' | sed 's/.$//g'`
        DOMAINS=`echo $DOMAINSTEMP | tr " " ,`
        echo "[\"$ip\",\"$DOMAINS\",\"$ports\",\"<a href='results/$ip'><button>Result</button></a>\"]," >> result.html
    done < ip_ports.txt 
    echo $OPTemplateTAIL >> result.html 
    # Scan completed cleaning the files 
    echo "[*] Scan Completed Successfully..."
    echo "[!] Removing Temp files..."
    rm masscanResults.txt 
    rm parsedResult.txt
    rm aliveIPs.txt
    rm ip_ports.txt
    echo "[!] Archieving files into result.tar"
    tar -cvf PortScanResult.tar result.html massdnsResults.txt results 
    echo "[*] Done!!..."
    echo "[!] Result File: PortScanResult.tar"
}

## Main Function Starts Here  
if [ ${#} -eq 1 ]  
then
    ScanServices $1
else
    Banner
fi
