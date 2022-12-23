#!/bin/bash
  declare -i i=0
  trap 'echo "Аварийное завершение..."; exit 1' SIGINT
  while [ $i -lt 100 ]
  do
  	(( i++ ))
  	echo $i
  	sleep 1
  done
