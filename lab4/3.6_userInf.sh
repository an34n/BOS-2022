#!/bin/bash 
COUNT=`echo -e "$USER$HOME" | tr -d "\n" | wc -c`
echo "$USER $HOME $COUNT"
