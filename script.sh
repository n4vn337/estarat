#!/bin/bash


# prereqs
# -------

$IP=$1

mkdir -p $IP/check_me $IP/origin


# subdomain enum
# --------------

amass enum -d $IP > origin/amass.txt
subfinder -d $IP -t 25 -timeout 5 -silent > origin/subfinder.txt

altdns -i check_me/subs.txt -o data_output -w ~/tools/words.txt -r -s origin/altdns.txt

echo origin/amass.txt> origin/origin_subs.txt; echo origin/subfinder.txt> origin/origin_subs.txt; echo origin/altdns.txt> origin/origin_subs.txt
uniq origin/origin_subs.txt> origin/hosts.txt
cat origin/hosts.txt | httpx -silent> origin/subs.txt
cp origin/subs.txt check_me/subs.txt
#sed -r 's/$/.$IP/' -i all.txt
#massdns -r lists/resolvers.txt -t CNAME all.txt -o s > results


# screenshot
# ----------

cat check_me/subs.txt | aquatone -chrome-path ~/tools/latest/chrome -out aquatone


# vulns
# ------------------

subjack -w check_me/subs.txt -t 100 -timeout 30 -o origin/subjack.txt -ssl
# cat origin/subjack.txt | 

nuclei -l chec_me/subs.txt -t ~/tools/nuclei-templates/*/


# service enum/ port scan
# -----------------------

# while read -r line; do masscan -p1-65535 $(dig +short $line) --rate 10000; done < subs.txt|tee ports
# while read -r line; do nmap -sV -p <ports from masscan> $IP --min-rate=10000; done < subs.txt

cat check_me/subs.txt | naabu -nmap-cli 'nmap -sV -oX check_me/naabu-output'


# links to check
# --------------

# linkfinder -i "https://www.$IP/" -d -o cli
while read -r line; do python linkfinder.py -i "https://$line" -d -o cli; done< check_me/subs.txt | tee origin/linkfinder.txt

cp origin/linkfinder.txt check_me/linkfinder.txt
# echo "www.$IP" | otxurls
# echo "www.$IP" | waybackurls
