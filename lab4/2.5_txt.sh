#!/bin/bash
find ~ -type f -name "*.txt" > /tmp/tmp.txt
cat /tmp/tmp.txt | xargs du -bc 2>/dev/null | tail -1 | cut -f1
cat /tmp/tmp.txt  | xargs wc -l 2>/dev/null | tail -1 | awk '{print $1}'
rm /tmp/tmp.txt
