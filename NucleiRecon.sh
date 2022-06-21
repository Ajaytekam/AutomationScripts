#!/bin/bash  

Banner() {
    echo -e "${CYN}Usage: ${0} <SubDomain_FileName>${END}"   
    exit 0
}

NucleiScan() {
    SUBDFILE=$1
    mkdir nucleiScan
    echo "[!] Nuclei : Scan Started for $SUBDFILE" 
    echo "[+] CVEs scan started.." 
    nuclei -t cves/ -l $SUBDFILE -o nucleiScan/cves.txt --silent
    echo "[*] Done.." 
    echo "[+] Default-logins scan started.." 
    nuclei -t default-logins/ -l $SUBDFILE -o nucleiScan/default_logins.txt --silent
    echo "[*] Done.." 
    echo "[+] Exposures scan started.."   
    nuclei -t exposures/ -l $SUBDFILE -o nucleiScan/exposures.txt --silent 
    echo "[*] Done.." 
    echo "[+] Misconfigurations scan started.."  
    nuclei -t misconfiguration/ -l $SUBDFILE -o nucleiScan/misconfigurations.txt --silent   
    echo "[*] Done.." 
    echo "[+] SubDomain Takeovers scan started.."   
    nuclei -t takeovers/ -l $SUBDFILE -o nucleiScan/takeovers.txt --silent
    echo "[*] Done.." 
    echo "[+] Vulnerability scan started.."   
    nuclei -t vulnerabilities/ -l $SUBDFILE -o nucleiScan/bulnerabilities.txt --silent
    echo "[*] Done.." 
    echo "[!] Nuclei : Scan Completed for $SUBDFILE" 
    echo "[!] nuclei : Output is stored on './nucleiScan/' folder.." 
}

## Main Function Starts Here  

if [ ${#} -eq 1 ]  
then
    # update nuclei  
    nuclei --update-templates 
    NucleiScan $1
else
    Banner
fi
