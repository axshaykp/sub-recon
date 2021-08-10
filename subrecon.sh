#!/bin/bash


if [ $# -eq 0 ]; then
    echo -e "Enter a domain.\neg : $0 example.com"
    exit 1
fi

mkdir /tmp/recon

echo "Finding subdomains..."
assetfinder -subs-only $1 > /tmp/recon/tmp_allsubs.txt
allcount=$(cat /tmp/recon/tmp_allsubs.txt | wc -l)
echo "Found ${allcount} subdomains"

echo "Filtering dead subdomains..."
cat /tmp/recon/tmp_allsubs.txt | httprobe > /tmp/recon/tmp_alive.txt

echo "Filtering duplicates..."
while read url ; do
    echo ${url#*//} >> /tmp/recon/tmp_filter.txt
done < /tmp/recon/tmp_alive.txt

sort -u /tmp/recon/tmp_filter.txt > $1_subdomains.txt
count=$(cat $1_subdomains.txt | wc -l)
echo -e "Filtering completed.\nRemoving temporary files..."
rm -rf /tmp/recon
echo -e "Process finished.\nFound ${count} alive subdomains out of total ${allcount} subdomains for $1"


read -p "Show found subdomains of $1? [y/n]" -n 1 -r
echo " "
if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
    echo "Done.Subdomains saved to $1_subdomains.txt"
else
    echo " "
    cat $1_subdomains.txt
    echo " "
    echo "Subdomains saved to $1_subdomains.txt"
fi
