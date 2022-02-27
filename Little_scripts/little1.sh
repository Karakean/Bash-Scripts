#!/bin/bash
grep "OK DOWNLOAD" cdlinux.ftp.log | cut -d '"' -f 2,4| grep "iso$" |  sort -u | grep -o  "cdlinux-.*" > tekst.txt
cut -d " " -f 1,7,9 cdlinux.www.log | grep "200$" | sort -u | cut -d " " -f 2 |  grep -o  "cdlinux-.*\.iso"  >> tekst.txt
cat<tekst.txt | sort | uniq -c 