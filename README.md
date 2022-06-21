# Automation Scripts for Checking WebApp Security | Bug Bounty

![](img.png)  

- [BrokenLinkCheck.sh](#brokenlinkchecksh)   
- [CORSMisconfig.sh](#corsmisconfigsh)    
- [CheckWildCard.sh](#checkwildcardsh)   
- [DirBruteffuf.sh](#dirbruteffufsh)   
- [HostHeaderInjection.sh](#hostheaderinjectionsh)   
- [NucleiRecon.sh](#nucleireconsh)   
- [ServiceRecon.sh](#servicereconsh)    
- [CheckDNS.sh](#checkdnssh)    

## [BrokenLinkCheck.sh](BrokenLinkCheck.sh)   

This is a supporting script which uses [lychee](https://github.com/lycheeverse/lychee) to check broken links and store results on a folder with respective domnain names in it. It takes file as input with the list of fully qualified domain names (https://example.com).      

__Example :__  

```
./BrokenLinkCheck.sh domains.txt  
```

Output Dirctory 

```  
BrokenLinkCheck
├── altoromutual.com
├── testasp.vulnweb.com
├── testaspnet.vulnweb.com
└── testphp.vulnweb.com
```  

__Installation :__   

Instructions to install lychee can be found [here](https://github.com/lycheeverse/lychee#installation)   

## [CORSMisconfig.sh](CORSMisconfig.sh)    

Check for [CORS Misconfiguration](https://sec-art.net/2021/12/14/cors-misconfiguration-vulnerability-explained-owasp-top-10-2021-broken-access-control/) on given domain name of list of domain names. This is a supporting wrapper script which uses httpxm, rush and xargs to check for cors misconfiguration. 

__Example :__   

__With single domain :__  

```
 ./CORSMisconfig.sh altoromutual.com

[+] Checking Domain..
[+] Checking for CORS Misconfiguration on : https://altoromutual.com
[+] Test Completed....
```  

Result is stored on CORSMiconfig.txt, if no misconfiguration found then the CORSMisconfig.txt will be empty.  

__With multiple domains :__  

```  
 ./CORSMisconfig.sh altoromutual.com
[+] Checking Domain..
[+] Checking for CORS Misconfiguration on : https://altoromutual.com
[+] Test Completed....
```  

Result is stored on CORSMiconfig.txt, if no misconfiguration found then the CORSMisconfig.txt will be empty.  

__Installation :__  

httpx : 

```   
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest 
```   

rush : Download binaries from [here](https://github.com/shenwei356/rush#installation) and put it on `/usr/local/bin`.    

xargs : `sudo apt install xargs -y`   

## [CheckWildCard.sh](CheckWildCard.sh)      

Check the dns has wildcard enabled or not for a domain.  

* If wildcard dns is enable then it is not suitable to bruteforce for subdomain enumeration.   
* If wildcard dns is disable then go for bruteforce for subdomain enumeration.   


Takes input as a domain name or file with multiple domain/subdomains.   


Example with single domain 

```   
./CheckWildCard.sh olx.com
[!] Wildcard detected.. exiting
```  

Example with multiple domains in a file as input  

```    
./CheckWildCard.sh google.com  
[+] Did not detect wildcard
[+] Safe to bruteforce for subdomains..
```  

## [DirBruteffuf.sh](DirBruteffuf.sh)      

Supporting script for [ffuf](https://github.com/ffuf/ffuf) to perform directory bruteforce. Takes input as a single domain name (fqdn) or file lists with multiple domain names.   

__Installation :__   

Install ffuf with 

```  
go install github.com/ffuf/ffuf@latest
```   

You also have to configure wordlist file on variable `WORDLIST` 

```   
WORDLIST="/root/tools/wordlists/small_wordlist.txt"
```  

Multiple goood wordlists can be found here : [SecLists](https://github.com/danielmiessler/SecLists/tree/master/Discovery/Web-Content)   

__Example :__   

```  
./DirBruteffuf.sh

Usage: ./DirBruteffuf.sh [Domains_List_File|Domain_Name] [-d <seconds>]

Example Usage :

        ./DirBruteffuf.sh Domains.txt
        ./DirBruteffuf.sh https://google.com
        ./DirBruteffuf.sh Domains.txt -d 1
        ./DirBruteffuf.sh https://google.com -d 1

Possible second values are 1, 2, 3, 0.1, 0.2, 0.3, 0.4....
```  

Using with single domain :  

```   
./DirBruteffuf.sh http://altoromutual.com
```  

```  
$ cat altoromutual.com.txt 

"url:http://altoromutual.com/admin status:302 length:0 [content-type:] redirect:/login.jsp"
"url:http://altoromutual.com/bank status:302 length:0 [content-type:] redirect:/login.jsp"
"url:http://altoromutual.com/aux status:200 length:0 [content-type:] redirect:"
"url:http://altoromutual.com/com3 status:200 length:0 [content-type:] redirect:"
"url:http://altoromutual.com/com4 status:200 length:0 [content-type:] redirect:"
"url:http://altoromutual.com/con status:200 length:0 [content-type:] redirect:"
"url:http://altoromutual.com/com1 status:200 length:0 [content-type:] redirect:"
"url:http://altoromutual.com/com2 status:200 length:0 [content-type:] redirect:"
"url:http://altoromutual.com/images status:302 length:0 [content-type:] redirect:/images/"
"url:http://altoromutual.com/lpt1 status:200 length:0 [content-type:] redirect:"
"url:http://altoromutual.com/lpt2 status:200 length:0 [content-type:] redirect:"
"url:http://altoromutual.com/nul status:200 length:0 [content-type:] redirect:"
"url:http://altoromutual.com/pr status:302 length:0 [content-type:] redirect:/pr/"
"url:http://altoromutual.com/prn status:200 length:0 [content-type:] redirect:"
"url:http://altoromutual.com/static status:302 length:0 [content-type:] redirect:/static/"
"url:http://altoromutual.com/util status:302 length:0 [content-type:] redirect:/util/"
```  

Using file as an input with multiple domains 

```  
./DirBruteffuf.sh lists.txt  
```   

Output Directory 

```  
Dirbruteforce/
├── altoromutual.com.txt
├── testasp.vulnweb.com.txt
├── testaspnet.vulnweb.com.txt
└── testphp.vulnweb.com.txt
```   

## [HostHeaderInjection.sh](HostHeaderInjection.sh)      

Check for [Host header injection](https://portswigger.net/web-security/host-header) on given domain or list of domains.    

__Installation :__   

httpx : 

```   
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest 
```   

rush : Download binaries from [here](https://github.com/shenwei356/rush#installation) and put it on `/usr/local/bin`.    

xargs : `sudo apt install xargs -y`   

__Example :__   

```  
./HostHeaderInjection.sh

Usage: ./HostHeaderInjection.sh [Domains_List_File|Domain_Name]

Example Usage :

        ./HostHeaderInjection.sh SubDomains.txt
        ./HostHeaderInjection.sh domain.com

Result : Stored on 'HostHeaderInjection.txt'
```   

With single domain 

```  
./HostHeaderInjection.sh altoromutual.com    

[+] Checking Domain..
[+] Checking for Host Header Injection on : https://altoromutual.com
[+] Test Completed....
```   

With multiple domains  

```  
./HostHeaderInjection.sh lists.txt   

[+] Checking Alive Subdomains..
[+] Checking for Host Header Injection..
[+] Test Completed....
```   

## [NucleiRecon.sh](NucleiRecon.sh)     

Supporting scripts to automate [nuclei](https://github.com/projectdiscovery/nuclei) vulnerability scanner. 

__Installation :__   

```  
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
```  

__Example :__    

```  
./NucleiRecon.sh lists.txt 
```  

Resulsts are stored on nucleiScan folder.    

## [ServiceRecon.sh](ServiceRecon.sh)       

Supporting script for masscan and nmap to scan only open ports on target network. Takes massdns result file as input, then perform port scan on them using masscan after that run detailed nmap scan on only open ports.  

__Installation :__    

nmap : `sudo apt install nmap -y`  

masscan : Follow the build instruction from [here](https://github.com/robertdavidgraham/masscan).     

__Example :__   

```   
./ServiceRecon.sh massdnsresults.txt   
```    

The result files are stored in "results" folder.    

## [CheckDNS.sh](CheckDNS.sh)      

Check DNS records of a Domain/Subdomain.   

```   
./CheckDNS.sh google.com  

[+] 142.250.183.78
[+] OrgName:        Google LLC
```  

