#!/bin/bash
#test
if [ $# -eq 0 ]; then
    echo -e "Enter a domain.\neg : $0 example.com"
    exit 1
fi

dom=$1
echo "Looking for subdomains of ${dom}"
assetfinder -subs-only ${dom} \
	| httprobe \
	| awk -F '//' '{ print $2 }' \
	| sort -u > ${dom}_subdomains.txt
echo -e "Found $(cat ${dom}_subdomains.txt | wc -l) subdomains of ${dom} and saved to ${dom}_subdomains.txt"
read -p "Show subdomains? [y/n] : " reply
if [[ ${reply} =~ ^[Yy]$ ]]
    then
    cat ${dom}_subdomains.txt
fi
