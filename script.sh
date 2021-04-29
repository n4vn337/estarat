#!/bin/bash


# prereqs
# -------

$IP=$1

cp all.txt $IP
mkdir -p $IP/check_me $IP/origin


# subdomain enum
# --------------

amass enum -d $IP > origin/amass.txt
subfinder -d $IP -t 25 -timeout 5 -silent > origin/subfinder.txt
echo origin/amass.txt> origin/origin_subs.txt; echo origin/subfinder.txt> origin/origin_subs.txt
uniq origin/origin_subs.txt> origin/hosts.txt
cat origin/hosts.txt | httpx -silent> origin/subs.txt
cp origin/subs.txt check_me/subs.txt

#sed -r 's/$/.$IP/' -i all.txt
#massdns -r lists/resolvers.txt -t CNAME all.txt -o s > results


# service enum/ port scan
# -----------------------

#masscan -p1-65535 $(dig +short $IP) --rate 10000
#nmap -sV -p <ports from masscan> $IP --min-rate=10000

# while read -r line; do masscan -p1-65535 $(dig +short $line) --rate 10000; done < subs.txt|tee ports
# while read -r line; do nmap -sV -p <ports from masscan> $IP --min-rate=10000; done < subs.txt

cat check_me/subs.txt | naabu -nmap-cli 'nmap -sV -oX check_me/naabu-output'


# links to check
# --------------

# linkfinder -i "https://www.$IP/" -d -o cli
while read -r line; do python linkfinder.py -i "https://$line" -d -o cli; done<~/Desktop/subs.txt | tee origin/links.txt

# echo "www.$IP" | otxurls
# echo "www.$IP" | waybackurls

# screenshot
# ----------

cat check_me/subs.txt | aquatone -chrome-path /root/hacking/chromium-latest-linux/latest/chrome

