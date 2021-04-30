#!/bin/bash


# prereqs
# -------

# $IP=$1

mkdir -p $1/check_me $1/origin
cd $1

# subdomain enum
# --------------

/snap/bin/amass enum -d $1 > amass.txt
subfinder -d $1 -t 25 -timeout 5 -silent > subfinder.txt

altdns -i check_me/subs.txt -o data_output -w ~/tools/words.txt -r -s altdns.txt

echo amass.txt> origin_subs.txt; echo subfinder.txt> origin_subs.txt; echo altdns.txt> origin_subs.txt
uniq origin_subs.txt> hosts.txt
cat hosts.txt | httpx -silent> subs.txt
#sed -r 's/$/.$1/' -i all.txt
#massdns -r lists/resolvers.txt -t CNAME all.txt -o s > results


# screenshot
# ----------

cat check_me/subs.txt | aquatone -chrome-path ~/tools/latest/chrome -out aquatone


# vulns
# ------------------

subjack -w check_me/subs.txt -t 100 -timeout 30 -o subjack.txt -ssl
# cat subjack.txt | 

nuclei -l chec_me/subs.txt -t ~/tools/nuclei-templates/*/


# service enum/ port scan
# -----------------------

# while read -r line; do masscan -p1-65535 $(dig +short $line) --rate 10000; done < subs.txt|tee ports
# while read -r line; do nmap -sV -p <ports from masscan> $1 --min-rate=10000; done < subs.txt

cat check_me/subs.txt | naabu -nmap-cli 'nmap -sV -oX naabu.txt'


# links to check
# --------------

# linkfinder -i "https://www.$1/" -d -o cli
while read -r line; do python linkfinder.py -i "https://$line" -d -o cli; done< check_me/subs.txt | tee linkfinder.txt

# echo "www.$1" | otxurls
# echo "www.$1" | waybackurls


copying files to check_me
-------------------------

cp subs.txt check_me/subs.txt
cp subjack.txt check_me/subjack.txt
cp naabu.txt check_me/naabu.txt
cp linkfinder.txt check_me/linkfinder.txt
