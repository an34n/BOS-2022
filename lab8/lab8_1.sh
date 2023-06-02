#!/bin/bash

services=$(systemctl list-units --type=service | head -n-6 | tail -n+2 | cut -c 3- |  cut -d" " -f 1)

for s in $services; do
  permissions=$(gerfacl $s  2>/dev/null | grep -v -E "^#" | grep -v "user::" | grep -E ":.w.$")
  unit=$(systemctl status $s | head -n+2 | tail -n-1 | cut -f2 -d"(" | cut -f1 -d";")
  user=$(grep "User=" "$unit") 
  if [ ! -z "$perms" ]; then
    echo "$s имеет $unit со следующими правами: $permissions"
  fi
  IFS=$'\n' read -r -d '' -a arr < <(grep -E "(ExecStart|ExecStartPre|ExecStartPost|ExecReload|ExecStop|ExecStopPost)=" "$unit" && printf '\0')
  #echo "$arr"
  for opt in "${arr[@]}"; do
    exe=$(cut -f1 -d" " <<< "${opt#*=}")
    #echo "$exe"
    exe="${exe/#-/}"
    exe_perms=$(getfacl $opt 2>/dev/null | grep -v -E "^#" | grep -v "user::" | grep -E ":.w.$")
    if [ ! -z $exe_perms ]; then
      echo "$s имеет $unit со следующими правами: $exe_perms"
    fi
    #echo "$exe"
    if [ ! "$user" = "User=root" ]; then
      owner=$(stat -c '%U' "$exe" 2>/dev/null)
      if [ "$owner" = "root" ]; then
        if stat -L -c '%A' "$exe" | grep -q "s"; then
          echo "$s запущен под $user ,но имеет $unit с suid, guid, принадлежащими root"
        fi
      fi
    fi
  done
done




